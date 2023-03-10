FROM nvidia/cuda:11.1-runtime-ubuntu18.04

# This is very similar to the `smasher` image, but comes with OpenBLAS and some
# of the other libraries required for fancyimpute.

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:apt-fast/stable
RUN apt-get update -qq
# via https://github.com/ilikenwf/apt-fast/issues/85#issuecomment-261640099
RUN echo debconf apt-fast/maxdownloads string 16 | debconf-set-selections
RUN echo debconf apt-fast/dlflag boolean true | debconf-set-selections
RUN echo debconf apt-fast/aptmanager string apt-get | debconf-set-selections
RUN _APTMGR=apt-get apt-get --no-install-recommends install -y apt-fast && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive; \
    export DEBCONF_NONINTERACTIVE_SEEN=true; \
    echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections; \
    echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections; \
    apt-get update -qqy \
 && apt-get install -qqy --no-install-recommends \
        tzdata \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY workers/CRAN.gpg .
RUN \
  apt-fast update -qq && \
  apt-fast install -y lsb-release && \
  echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" \
      >> /etc/apt/sources.list.d/added_repos.list && \
  apt-key add CRAN.gpg && \
  apt-fast update -qq && \
  apt-fast install -y \
  ed \
  git \
  liblapack-dev \
  libopenblas-dev \
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

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/ && rm phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/

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
RUN pip3 install --no-cache-dir numpy scipy matplotlib pandas==0.25.3 scikit-learn sympy nose rpy2===3.4.5 tzlocal fancySVD
# End smasher-specific

COPY config/ config/
COPY .boto .boto

COPY workers/data_refinery_workers/processors/requirements.txt .

RUN  pip3 --no-cache-dir install -r requirements.txt
RUN pip3 install --no-cache-dir numpy==1.16.0# Fix a downgrade

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
