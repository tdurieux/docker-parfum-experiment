FROM ubuntu:18.04

MAINTAINER William Stein <wstein@sagemath.com>

USER root

# See https://github.com/sagemathinc/cocalc/issues/921
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM screen


# So we can source (see http://goo.gl/oBPi5G)
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Ubuntu software that are used by CoCalc (latex, pandoc, sage, jupyter)
RUN \
     apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       software-properties-common \
       texlive \
       texlive-latex-extra \
       texlive-extra-utils \
       texlive-xetex \
       texlive-luatex \
       texlive-bibtex-extra \
       liblog-log4perl-perl

RUN \
    apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       tmux \
       flex \
       bison \
       libreadline-dev \
       htop \
       screen \
       pandoc \
       aspell \
       poppler-utils \
       net-tools \
       wget \
       git \
       python \
       python-pip \
       make \
       g++ \
       sudo \
       psmisc \
       haproxy \
       nginx \
       yapf \
       rsync \
       tidy

 RUN \
     apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       vim \
       bup \
       inetutils-ping \
       lynx \
       telnet \
       git \
       emacs \
       subversion \
       ssh \
       m4 \
       latexmk \
       libpq5 \
       libpq-dev \
       build-essential \
       automake

RUN \
   apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
       gfortran \
       dpkg-dev \
       libssl-dev \
       imagemagick \
       libcairo2-dev \
       libcurl4-openssl-dev \
       graphviz \
       smem \
       octave \
       python3-yaml \
       python3-matplotlib \
       python3-jupyter* \
       python-matplotlib* \
       python-jupyter* \
       jupyter \
       locales \
       locales-all \
       postgresql \
       postgresql-contrib \
       clang-format \
       yapf \
       yapf3 \
       golang \
       r-cran-formatr

# The Octave kernel.
RUN \
  pip install octave_kernel

# Jupyter Lab
RUN \
  pip install jupyterlab

# Install LEAN proof assistant
RUN \
     export VERSION=3.4.1 \
  && mkdir -p /opt/lean \
  && cd /opt/lean \
  && wget https://github.com/leanprover/lean/releases/download/v$VERSION/lean-$VERSION-linux.tar.gz \
  && tar xf lean-$VERSION-linux.tar.gz \
  && rm lean-$VERSION-linux.tar.gz \
  && rm -f latest \
  && ln -s lean-$VERSION-linux latest \
  && ln -s /opt/lean/latest/bin/lean /usr/local/bin/lean

# Install all aspell dictionaries, so that spell check will work in all languages.  This is
# used by cocalc's spell checkers (for editors).  This takes about 80MB, which is well worth it.
RUN \
     apt-get update \
  && apt-get install -y aspell-*

# Install Node.js and LATEST version of npm
RUN \
     wget -qO- https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y nodejs \
  && /usr/bin/npm install -g npm

# Install Julia
ARG JULIA=0.6.3
RUN cd /tmp \
 && wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-${JULIA}-linux-x86_64.tar.gz \
 && tar xf julia-${JULIA}-linux-x86_64.tar.gz -C /opt \
 && rm  -f julia-${JULIA}-linux-x86_64.tar.gz \
 && mv /opt/julia-* /opt/julia \
 && ln -s /opt/julia/bin/julia /usr/local/bin

# Commit to checkout and build.
ARG commit=HEAD

# Pull latest source code for CoCalc and checkout requested commit (or HEAD)
RUN \
     git clone https://github.com/sagemathinc/cocalc.git \
  && cd /cocalc && git pull && git fetch origin && git checkout ${commit:-HEAD}

# Build and install all deps
# CRITICAL to install first web, then compute, since compute precompiles all the .js
# for fast startup, but unfortunately doing so breaks ./install.py all --web, since
# the .js files laying around somehow mess up cjsx loading.
RUN \
     cd /cocalc/src \
  && . ./smc-env \
  && ./install.py all --web \
  && ./install.py all --compute \
  && rm -rf /root/.npm /root/.node-gyp/

RUN echo "umask 077" >> /etc/bash.bashrc

# Install some Jupyter kernel definitions
COPY kernels /usr/local/share/jupyter/kernels

# Build a UTF-8 locale, so that tmux works -- see https://unix.stackexchange.com/questions/277909/updated-my-arch-linux-server-and-now-i-get-tmux-need-utf-8-locale-lc-ctype-bu
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Install IJulia kernel
#RUN echo '\
#ENV["JUPYTER"] = "/usr/local/bin/jupyter"; \
#ENV["JULIA_PKGDIR"] = "/opt/julia/share/julia/site"; \
#Pkg.init(); \
#Pkg.add("IJulia");' | julia \
# && mv -i "$HOME/.local/share/jupyter/kernels/julia-0.6" "/usr/local/share/jupyter/kernels/"


### Configuration

COPY login.defs /etc/login.defs
COPY login /etc/defaults/login
COPY nginx.conf /etc/nginx/sites-available/default
COPY haproxy.conf /etc/haproxy/haproxy.cfg
COPY run.py /root/run.py
COPY bashrc /root/.bashrc

## Xpra backend support -- we have to use the debs from xpra.org,
## Since the official distro packages are ancient.
RUN \
     apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y xvfb websockify curl \
  && curl https://xpra.org/gpg.asc | apt-key add - \
  && echo "deb http://xpra.org/ bionic main" > /etc/apt/sources.list.d/xpra.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y xpra

## X11 apps to make x11 support useful.
## Will move this up in Dockerfile once stable.
RUN \
     apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y x11-apps dbus-x11 gnome-terminal \
     vim-gtk lyx libreoffice inkscape gimp chromium-browser texstudio evince mesa-utils \
     xdotool xclip x11-xkb-utils

# Microsoft's VS Code
RUN \
     curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
  && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
  && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y apt-transport-https \
  && sudo apt-get update \
  && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y code

# RStudio
RUN \
     apt-get install -y libjpeg62 \
  && wget -O rstudio.deb https://download1.rstudio.org/rstudio-xenial-1.1.463-amd64.deb \
  && dpkg -i rstudio.deb \
  && rm rstudio.deb

# User that the database, servers, etc. run under
RUN    adduser --quiet --shell /bin/bash --gecos "Sage user,101,," --disabled-password sage \
    && chown -R sage:sage /home/sage/


CMD /root/run.py

EXPOSE 80 443
