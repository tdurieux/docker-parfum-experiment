FROM ubuntu:18.04

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:apt-fast/stable
RUN apt-get update -qq
RUN apt-get -y --no-install-recommends install apt-fast && rm -rf /var/lib/apt/lists/*;

# The packages related to R are somewhat weird, see the README for more details.

COPY workers/CRAN.gpg .
RUN \
  apt-fast update -qq && \
  apt-get install --no-install-recommends -y apt-transport-https && \
  apt-fast install -y lsb-release && \
  echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" \
      >> /etc/apt/sources.list.d/added_repos.list && \
  apt-key add CRAN.gpg && \
  apt-fast update -qq && rm -rf /var/lib/apt/lists/*;

# Prevent tzdata from prompting us for a timezone and hanging the build.
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-fast install -y \
  ed \
  git \
  mercurial \
  libcairo-dev \
  libedit-dev \
  lsb-release \
  python3 \
  python3-pip \
  r-base-core \
  r-base-dev \
  libpq-dev \
  libxml2-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  curl \
  wget && \
  rm -rf /var/lib/apt/lists/*

RUN rm CRAN.gpg

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
WORKDIR /home/user

ENV R_LIBS "/usr/local/lib/R/site-library"

COPY common/install_devtools.R .

RUN Rscript install_devtools.R

COPY workers/R_dependencies/illumina/dependencies.R .
RUN Rscript dependencies.R

# These are for Illumina
COPY workers/illumina_dependencies.R .
RUN Rscript illumina_dependencies.R

# Source: https://github.com/thisbejim/Pyrebase/issues/87#issuecomment-354452082
# For whatever reason this worked and 'en_US.UTF-8' did not.
ENV LANG C.UTF-8

RUN pip3 install --no-cache-dir --upgrade pip

COPY config/ config/
COPY .boto .boto

COPY workers/illumina_probe_maps/ probe_maps/

COPY workers/data_refinery_workers/processors/requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY common/dist/data-refinery-common-* common/

# Get the latest version from the dist directory.
RUN pip3 install --no-cache-dir common/$(ls common -1 | sort --version-sort | tail -1)

# Clear our the pip3 cache
RUN rm -rf /root/.cache

ARG SYSTEM_VERSION

ENV SYSTEM_VERSION $SYSTEM_VERSION

USER user

COPY workers/data_refinery_workers/processors/detect_database.R .
COPY workers/ .

ENTRYPOINT []
