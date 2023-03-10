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
  libcurl4-openssl-dev \
  libpq-dev \
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

# We need a few special packages for QN
ENV R_LIBS "/usr/local/lib/R/site-library"

COPY common/install_devtools.R .

RUN Rscript install_devtools.R

COPY workers/R_dependencies/qn/dependencies.R .
RUN Rscript dependencies.R

COPY workers/qn_dependencies.R .
RUN Rscript qn_dependencies.R
# End QN-specific

# Source: https://github.com/thisbejim/Pyrebase/issues/87#issuecomment-354452082
# For whatever reason this worked and 'en_US.UTF-8' did not.
ENV LANG C.UTF-8

RUN pip3 install --no-cache-dir --upgrade pip

# Smasher-specific requirements
RUN pip3 install --no-cache-dir numpy scipy matplotlib pandas==0.25.3 scikit-learn sympy nose rpy2==3.4.5 tzlocal
# End smasher-specific

COPY config/ config/
COPY .boto .boto

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

COPY workers/ .

ENTRYPOINT []
