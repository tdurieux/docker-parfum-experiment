FROM ubuntu:bionic

# Install necessary binary
RUN apt-get update && apt-get -y --no-install-recommends install \
    bash \
    build-essential \
    ca-certificates \
    curl \
    gettext \
    git \
    netcat-openbsd \
    python3-dev \
    python3-setuptools \
    rsync \
    ssh \
    unzip \
    zip \
    && true && rm -rf /var/lib/apt/lists/*;
# netcat for `bosh ssh` -- the why is explained here: https://github.com/cloudfoundry/bosh-cli/issues/374

# pip
# Install via source as upgrading the pip installed from Ubuntu leaves unwanted artifacts.
# ERROR: This script does not work on Python 3.6 The minimum supported Python version is 3.7.
# Please use https://bootstrap.pypa.io/pip/3.6/get-pip.py instead.
RUN curl -f https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py && \
    python3 get-pip.py

# gcloud
RUN curl -f https://sdk.cloud.google.com > install.sh && bash install.sh --disable-prompts
ENV PATH /root/google-cloud-sdk/bin:$PATH
RUN ln -s /root/google-cloud-sdk/bin/* /usr/local/bin/
RUN gcloud --version

# azure
RUN pip3 install --no-cache-dir azure-cli --use-feature=2020-resolver
RUN az --version

# aws
RUN pip3 install --no-cache-dir awscli --use-feature=2020-resolver
RUN aws --version

# openstack
RUN pip3 install --no-cache-dir python-openstackclient --use-feature=2020-resolver
RUN openstack --version

# Upgrade all packages
RUN apt-get upgrade -y
RUN apt-get autoremove -y build-essential python3-dev
