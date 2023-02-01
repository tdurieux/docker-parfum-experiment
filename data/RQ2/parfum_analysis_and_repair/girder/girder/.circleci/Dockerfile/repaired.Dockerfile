FROM circleci/python:3.6-node
LABEL maintainer="Kitware, Inc. <kitware@kitware.com>"

# Don't use "sudo"
USER root

# Install Girder system prereqs (including those for all plugins)
RUN apt-get update \
  && apt-get install -y --no-install-recommends --assume-yes \
    libldap2-dev \
    libsasl2-dev && rm -rf /var/lib/apt/lists/*;

# Install Girder development prereqs
RUN apt-get update \
  && apt-get install -y --no-install-recommends --assume-yes \
    cmake \
  # Note: universal-ctags is installed for use in the public_names CI job.
  && git clone "https://github.com/universal-ctags/ctags.git" "./ctags" \
  && cd ./ctags \
  && ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && cd .. \
  && rm -rf ./ctags \
  && pip3 install --no-cache-dir --no-cache --upgrade \
    pip \
    setuptools \
    tox && rm -rf /var/lib/apt/lists/*;

USER circleci
