FROM opensuse/leap:15.3

ENV OS_IDENTIFIER opensuse-153

# Most of these packages, and also the configure options that follow were determined
# by reviewing "R-base.spec" from the following OpenSUSE RPM:
# https://download.opensuse.org/repositories/devel:/languages:/R:/released/openSUSE_Leap_42.3/src/R-base-3.5.3-103.1.src.rpm

RUN zypper --non-interactive update
RUN zypper --non-interactive --gpg-auto-import-keys -n install \
    bzip2 \
    cairo-devel \
    fdupes \
    gcc \
    gcc-c++ \
    gcc-fortran \
    glib2-devel \
    glibc-locale \
    help2man \
    # openSUSE/SLES 15.3 originally shipped with ICU 65 (libicu-devel), but later
    # added ICU 69 (icu.691-devel) in a patch update. Prefer ICU 69 because the devel
    # packages can't coexist, and zypper now resolves libicu-devel to icu.691-devel.
    icu.691-devel \
    java-1_8_0-openjdk-devel \
    libX11-devel \
    libXScrnSaver-devel \
    libXmu-devel \
    libXt-devel \
    libbz2-devel \
    libcurl-devel \
    libjpeg-devel \
    libpng-devel \
    libtiff-devel \
    make \
    pango-devel \
    pcre-devel \
    pcre2-devel \
    perl \
    perl-macros \
    python \
    python-pip \
    readline-devel \
    rpm-build \
    ruby \
    ruby-devel \
    shadow \
    tcl-devel \
    texinfo \
    texlive-ae \
    texlive-bibtex \
    texlive-cm-super \
    texlive-dvips \
    texlive-fancyvrb \
    texlive-helvetic \
    texlive-inconsolata \
    texlive-latex \
    texlive-makeindex \
    texlive-metafont \
    texlive-psnfss \
    texlive-tex \
    texlive-times \
    tk-devel \
    unzip \
    wget \
    xdg-utils \
    xorg-x11-devel \
    xz-devel \
    zip \
    zlib-devel \
    && zypper clean

RUN pip install --no-cache-dir awscli

# Pin fpm to avoid git dependency in 1.12.0
RUN gem install fpm:1.11.0 && \
    ln -s /usr/bin/fpm.ruby2.5 /usr/local/bin/fpm

RUN chmod 0777 /opt

# Configure flags for SUSE that don't use the defaults in build.sh
ENV CONFIGURE_OPTIONS="\
    --enable-R-shlib \
    --with-tcltk \
    --with-x \
    --enable-memory-profiling \
    --with-tcl-config=/usr/lib64/tclConfig.sh \
    --with-tk-config=/usr/lib64/tkConfig.sh"

COPY package.opensuse-153 /package.sh
COPY build.sh .
ENTRYPOINT ./build.sh
