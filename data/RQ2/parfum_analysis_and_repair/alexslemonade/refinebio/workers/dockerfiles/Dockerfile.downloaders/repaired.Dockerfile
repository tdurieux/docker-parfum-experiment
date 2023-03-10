FROM ubuntu:18.04

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:apt-fast/stable
RUN apt-get update -qq
RUN apt-get -y --no-install-recommends install apt-fast && rm -rf /var/lib/apt/lists/*;

# Prevent tzdata from prompting us for a timezone and hanging the build.
ENV DEBIAN_FRONTEND=noninteractive

# The packages related to R are somewhat weird, see the README for more details.

COPY workers/CRAN.gpg .
RUN \
  apt-fast update -qq && \
  apt-get install --no-install-recommends -y apt-transport-https && \
  apt-fast install -y lsb-release && \
  echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" \
      >> /etc/apt/sources.list.d/added_repos.list && \
  apt-key add CRAN.gpg && \
  apt-fast update -qq && \
  apt-fast install -y \
  ed \
  git \
  python3 \
  python3-pip \
  r-base-core \
  r-base-dev \
  libpq-dev \
  libxml2-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  libpq-dev \
  curl \
  wget && \
  rm -rf /var/lib/apt/lists/*
RUN rm CRAN.gpg

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
WORKDIR /home/user

# Source: https://github.com/thisbejim/Pyrebase/issues/87#issuecomment-354452082
# For whatever reason this worked and 'en_US.UTF-8' did not.
ENV LANG C.UTF-8

RUN pip3 install --no-cache-dir --upgrade pip

ENV R_LIBS "/usr/local/lib/R/site-library"

COPY common/install_devtools.R .

RUN Rscript install_devtools.R

COPY workers/install_downloader_R_only.R .

RUN Rscript install_downloader_R_only.R

# Aspera will only install as the current user.
# Even using `su - user &&` doesn't work...
USER user

# Install Aspera. We have to install it using Holland Computing Center's conda
# repo because download.asperasoft.com now returns 403s
RUN wget -q https://anaconda.org/HCC/aspera-cli/3.9.1/download/linux-64/aspera-cli-3.9.1-0.tar.bz2
RUN [ "$(sha256sum aspera-cli-3.9.1-0.tar.bz2 | cut -d' ' -f1)" = 60a09a7f3795186954079869106aa89a64183b7be8e0da7cbbe9d57c66c9bcdb ]
RUN mkdir -p .aspera/cli
RUN tar xf aspera-cli-3.9.1-0.tar.bz2 -C .aspera/cli && rm aspera-cli-3.9.1-0.tar.bz2
RUN rm aspera-cli-3.9.1-0.tar.bz2

# Now that we're done installing Aspera go back to being root for a bit.
USER root

COPY config config
COPY .boto .boto

COPY workers/data_refinery_workers/downloaders/requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

# Install this rpy2 here instead of via requirements.txt because
# pip-compile throws an error for it.
RUN pip3 install --no-cache-dir rpy2==3.4.5
COPY common/dist/data-refinery-common-* common/

# Get the latest version from the dist directory.
RUN pip3 install --no-cache-dir common/$(ls common -1 | sort --version-sort | tail -1)

# Clear our the pip3 cache
RUN rm -rf /root/.cache

ARG SYSTEM_VERSION

ENV SYSTEM_VERSION $SYSTEM_VERSION

USER user

COPY workers/ .

ENTRYPOINT []
