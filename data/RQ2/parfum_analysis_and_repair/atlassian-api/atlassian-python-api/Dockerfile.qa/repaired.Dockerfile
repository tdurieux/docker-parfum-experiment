FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION

# Install add-apt-repository
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# Add python repo
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update

# Install apt-utils
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;

# Install python development
RUN apt-get install --no-install-recommends -y \
  python$PYTHON_VERSION-dev \
  python3-pip && rm -rf /var/lib/apt/lists/*;

# install distutils.util
RUN if [ $PYTHON_VERSION = '3.7' ] ; then \
  apt-get install --no-install-recommends -y python$PYTHON_VERSION-distutils python3-distutils-extra python3-apt --reinstall; rm -rf /var/lib/apt/lists/*; \
  elif [ $PYTHON_VERSION = '3.6' ] ; then \
  apt-get install --no-install-recommends -y python$PYTHON_VERSION-distutils python3-distutils-extra python3-apt --reinstall; rm -rf /var/lib/apt/lists/*; \
  elif [ $PYTHON_VERSION != '3.10' ] ; then \
  apt-get install --no-install-recommends -y python3-distutils python3-distutils-extra python3-apt --reinstall; rm -rf /var/lib/apt/lists/*; \
  else \
  apt-get install --no-install-recommends -y python$PYTHON_VERSION-distutils python3-distutils-extra python3-apt --reinstall; rm -rf /var/lib/apt/lists/*; \
  curl -f -sS https://bootstrap.pypa.io/get-pip.py | python3.10; \
  fi

# Register the version in alternatives
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$PYTHON_VERSION 1

# Install kerberos development
RUN apt-get install --no-install-recommends -y libkrb5-dev && rm -rf /var/lib/apt/lists/*;

# Clean
RUN apt-get clean

# Install modules
WORKDIR /atlassian-python-api
COPY requirements.txt .
COPY requirements-dev.txt .
RUN python3 -m pip install --no-cache-dir --upgrade pip
RUN python3 -m pip install --no-cache-dir -r requirements-dev.txt

ENV PYTHON_VERSION=$PYTHON_VERSION
# Select language-agnostic "C" locale.
# Unicode is necessary for some tools like "black" to work.
ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

CMD python3 -m pip install -e . && \
  make qa PYTHON_VERSION=$PYTHON_VERSION
