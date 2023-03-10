# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# WARNING: THIS DOCKERFILE IS NOT INTENDED FOR PRODUCTION USE OR DEPLOYMENT.
#
ARG PYTHON_BASE_IMAGE="python:3.6-slim-buster"
FROM ${PYTHON_BASE_IMAGE} as main

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-u", "-x", "-c"]

ARG PYTHON_BASE_IMAGE="python:3.6-slim-buster"
ENV PYTHON_BASE_IMAGE=${PYTHON_BASE_IMAGE}

ARG AIRFLOW_VERSION="2.0.0.dev0"
ENV AIRFLOW_VERSION=$AIRFLOW_VERSION

ARG PYTHON_MAJOR_MINOR_VERSION="3.6"
ENV PYTHON_MAJOR_MINOR_VERSION=${PYTHON_MAJOR_MINOR_VERSION}

ARG PIP_VERSION=20.2.4
ENV PIP_VERSION=${PIP_VERSION}

# Print versions
RUN echo "Base image: ${PYTHON_BASE_IMAGE}"
RUN echo "Airflow version: ${AIRFLOW_VERSION}"

# Make sure noninteractive debian install is used and language variables set
ENV DEBIAN_FRONTEND=noninteractive LANGUAGE=C.UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    LC_CTYPE=C.UTF-8 LC_MESSAGES=C.UTF-8

# By increasing this number we can do force build of all dependencies
ARG DEPENDENCIES_EPOCH_NUMBER="5"
# Increase the value below to force reinstalling of all dependencies
ENV DEPENDENCIES_EPOCH_NUMBER=${DEPENDENCIES_EPOCH_NUMBER}

# Install curl and gnupg2 - needed to download nodejs in the next step
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
           curl \
           gnupg2 \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG ADDITIONAL_DEV_APT_DEPS=""
ENV ADDITIONAL_DEV_APT_DEPS=${ADDITIONAL_DEV_APT_DEPS}

ARG DEV_APT_COMMAND="\
    curl --fail --location https://deb.nodesource.com/setup_10.x | bash - \
    && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - > /dev/null \
    && echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list"
ENV DEV_APT_COMMAND=${DEV_APT_COMMAND}

ARG ADDITIONAL_DEV_APT_COMMAND=""
ENV ADDITIONAL_DEV_APT_COMMAND=${ADDITIONAL_DEV_APT_COMMAND}

ARG ADDITIONAL_DEV_ENV_VARS=""

# Install basic and additional apt dependencies
RUN mkdir -pv /usr/share/man/man1 \
    && mkdir -pv /usr/share/man/man7 \
    && export ${ADDITIONAL_DEV_ENV_VARS?} \
    && bash -o pipefail -e -u -x -c "${DEV_APT_COMMAND}" \
    && bash -o pipefail -e -u -x -c "${ADDITIONAL_DEV_APT_COMMAND}" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
           apt-utils \
           build-essential \
           dirmngr \
           dumb-init \
           freetds-bin \
           freetds-dev \
           git \
           graphviz \
           gosu \
           libffi-dev \
           libkrb5-dev \
           libpq-dev \
           libsasl2-2 \
           libsasl2-dev \
           libsasl2-modules \
           libssl-dev \
           libenchant-dev \
           locales  \
           netcat \
           nodejs \
           rsync \
           sasl2-bin \
           sudo \
           unixodbc \
           unixodbc-dev \
           yarn \
           ${ADDITIONAL_DEV_APT_DEPS} \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/docker /scripts/docker
# fix permission issue in Azure DevOps when running the script
RUN chmod a+x /scripts/docker/install_mysql.sh
RUN ./scripts/docker/install_mysql.sh dev

RUN adduser airflow \
    && echo "airflow ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/airflow \
    && chmod 0440 /etc/sudoers.d/airflow

# The latest buster images do not have libpython 2.7 installed and it is needed
# To run virtualenv tests with python 2
ARG RUNTIME_APT_DEPS="\
      gnupg \
      libgcc-8-dev \
      apt-transport-https \
      bash-completion \
      ca-certificates \
      software-properties-common \
      krb5-user \
      ldap-utils \
      less \
      libpython2.7-stdlib \
      lsb-release \
      net-tools \
      openssh-client \
      openssh-server \
      postgresql-client \
      sqlite3 \
      tmux \
      unzip \
      vim \
      xxd"
ENV RUNTIME_APT_DEP=${RUNTIME_APT_DEPS}

ARG ADDITIONAL_RUNTIME_APT_DEPS=""
ENV ADDITIONAL_RUNTIME_APT_DEPS=${ADDITIONAL_RUNTIME_APT_DEPS}

ARG RUNTIME_APT_COMMAND=""
ENV RUNTIME_APT_COMMAND=${RUNTIME_APT_COMMAND}

ARG ADDITIONAL_RUNTIME_APT_COMMAND=""
ENV ADDITIONAL_RUNTIME_APT_COMMAND=${ADDITIONAL_RUNTIME_APT_COMMAND}

ARG ADDITIONAL_RUNTIME_ENV_VARS=""

# Note missing man directories on debian-buster
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -pv /usr/share/man/man1 \
    && mkdir -pv /usr/share/man/man7 \
    && export ${ADDITIONAL_RUNTIME_ENV_VARS?} \
    && bash -o pipefail -e -u -x -c "${RUNTIME_APT_COMMAND}" \
    && bash -o pipefail -e -u -x -c "${ADDITIONAL_RUNTIME_APT_COMMAND}" \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
      ${RUNTIME_APT_DEPS} \
      ${ADDITIONAL_RUNTIME_APT_DEPS} \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG DOCKER_CLI_VERSION=19.03.9
ENV DOCKER_CLI_VERSION=${DOCKER_CLI_VERSION}

RUN curl -f https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz \
    | tar -C /usr/bin --strip-components=1 -xvzf - docker/docker

# Setup PIP
# By default PIP install run without cache to make image smaller
ARG PIP_NO_CACHE_DIR="true"
ENV PIP_NO_CACHE_DIR=${PIP_NO_CACHE_DIR}
RUN echo "Pip no cache dir: ${PIP_NO_CACHE_DIR}"

ARG HOME=/root
ENV HOME=${HOME}

ARG AIRFLOW_HOME=/root/airflow
ENV AIRFLOW_HOME=${AIRFLOW_HOME}

ARG AIRFLOW_SOURCES=/opt/airflow
ENV AIRFLOW_SOURCES=${AIRFLOW_SOURCES}

WORKDIR ${AIRFLOW_SOURCES}

RUN mkdir -pv ${AIRFLOW_HOME} && \
    mkdir -pv ${AIRFLOW_HOME}/dags && \
    mkdir -pv ${AIRFLOW_HOME}/logs

# Increase the value here to force reinstalling Apache Airflow pip dependencies
ARG PIP_DEPENDENCIES_EPOCH_NUMBER="3"
ENV PIP_DEPENDENCIES_EPOCH_NUMBER=${PIP_DEPENDENCIES_EPOCH_NUMBER}

# Install BATS and its dependencies for "in container" tests
ARG BATS_VERSION="0.4.0"
ARG BATS_SUPPORT_VERSION="0.3.0"
ARG BATS_ASSERT_VERSION="2.0.0"
ARG BATS_FILE_VERSION="0.2.0"

RUN curl -f -sSL https://github.com/bats-core/bats-core/archive/v${BATS_VERSION}.tar.gz -o /tmp/bats.tgz \
    && tar -zxf /tmp/bats.tgz -C /tmp \
    && /bin/bash /tmp/bats-core-${BATS_VERSION}/install.sh /opt/bats && rm -rf && rm /tmp/bats.tgz

RUN mkdir -p /opt/bats/lib/bats-support \
    && curl -f -sSL https://github.com/bats-core/bats-support/archive/v${BATS_SUPPORT_VERSION}.tar.gz -o /tmp/bats-support.tgz \
    && tar -zxf /tmp/bats-support.tgz -C /opt/bats/lib/bats-support --strip 1 && rm -rf /tmp/* && rm /tmp/bats-support.tgz

RUN mkdir -p /opt/bats/lib/bats-assert \
    && curl -f -sSL https://github.com/bats-core/bats-assert/archive/v${BATS_ASSERT_VERSION}.tar.gz -o /tmp/bats-assert.tgz \
    && tar -zxf /tmp/bats-assert.tgz -C /opt/bats/lib/bats-assert --strip 1 && rm -rf /tmp/* && rm /tmp/bats-assert.tgz

RUN mkdir -p /opt/bats/lib/bats-file \
    && curl -f -sSL https://github.com/bats-core/bats-file/archive/v${BATS_FILE_VERSION}.tar.gz -o /tmp/bats-file.tgz \
    && tar -zxf /tmp/bats-file.tgz -C /opt/bats/lib/bats-file --strip 1 && rm -rf /tmp/* && rm /tmp/bats-file.tgz

RUN echo "export PATH=/opt/bats/bin:${PATH}" >> /root/.bashrc

# Additional scripts for managing BATS addons
COPY scripts/docker/load.bash /opt/bats/lib/
RUN chmod a+x /opt/bats/lib/load.bash


# Optimizing installation of Cassandra driver
# Speeds up building the image - cassandra driver without CYTHON saves around 10 minutes
ARG CASS_DRIVER_NO_CYTHON="1"
# Build cassandra driver on multiple CPUs
ARG CASS_DRIVER_BUILD_CONCURRENCY="8"

ENV CASS_DRIVER_BUILD_CONCURRENCY=${CASS_DRIVER_BUILD_CONCURRENCY}
ENV CASS_DRIVER_NO_CYTHON=${CASS_DRIVER_NO_CYTHON}

ARG AIRFLOW_REPO=apache/airflow
ENV AIRFLOW_REPO=${AIRFLOW_REPO}

ARG AIRFLOW_BRANCH=master
ENV AIRFLOW_BRANCH=${AIRFLOW_BRANCH}

# Airflow Extras installed
ARG AIRFLOW_EXTRAS="all"
ARG ADDITIONAL_AIRFLOW_EXTRAS=""
ENV AIRFLOW_EXTRAS=${AIRFLOW_EXTRAS}${ADDITIONAL_AIRFLOW_EXTRAS:+,}${ADDITIONAL_AIRFLOW_EXTRAS}

RUN echo "Installing with extras: ${AIRFLOW_EXTRAS}."

ARG AIRFLOW_CONSTRAINTS_REFERENCE="constraints-master"
ARG AIRFLOW_CONSTRAINTS_LOCATION="https://raw.githubusercontent.com/apache/airflow/${AIRFLOW_CONSTRAINTS_REFERENCE}/constraints-${PYTHON_MAJOR_MINOR_VERSION}.txt"
ENV AIRFLOW_CONSTRAINTS_LOCATION=${AIRFLOW_CONSTRAINTS_LOCATION}

# By changing the CI build epoch we can force reinstalling Airflow from the current master
# It can also be overwritten manually by setting the AIRFLOW_CI_BUILD_EPOCH environment variable.
ARG AIRFLOW_CI_BUILD_EPOCH="3"
ENV AIRFLOW_CI_BUILD_EPOCH=${AIRFLOW_CI_BUILD_EPOCH}

ARG AIRFLOW_PRE_CACHED_PIP_PACKAGES="true"
ENV AIRFLOW_PRE_CACHED_PIP_PACKAGES=${AIRFLOW_PRE_CACHED_PIP_PACKAGES}

# By default in the image, we are installing all providers when installing from sources
ARG INSTALL_PROVIDERS_FROM_SOURCES="true"
ENV INSTALL_PROVIDERS_FROM_SOURCES=${INSTALL_PROVIDERS_FROM_SOURCES}

ARG INSTALL_FROM_DOCKER_CONTEXT_FILES=""
ENV INSTALL_FROM_DOCKER_CONTEXT_FILES=${INSTALL_FROM_DOCKER_CONTEXT_FILES}

ARG INSTALL_FROM_PYPI="true"
ENV INSTALL_FROM_PYPI=${INSTALL_FROM_PYPI}

RUN pip install --no-cache-dir --upgrade "pip==${PIP_VERSION}"

# In case of CI builds we want to pre-install master version of airflow dependencies so that
# We do not have to always reinstall it from the scratch.
# This can be reinstalled from latest master by increasing PIP_DEPENDENCIES_EPOCH_NUMBER.
# And is automatically reinstalled from the scratch every time patch release of python gets released
RUN if [[ ${AIRFLOW_PRE_CACHED_PIP_PACKAGES} == "true" ]]; then \
        pip install --no-cache-dir \
            "https://github.com/${AIRFLOW_REPO}/archive/${AIRFLOW_BRANCH}.tar.gz#egg=apache-airflow[${AIRFLOW_EXTRAS}]" \
                --constraint "${AIRFLOW_CONSTRAINTS_LOCATION}" \
                && pip uninstall --yes apache-airflow; \
    fi

# Generate random hex dump file so that we can determine whether it's faster to rebuild the image
# using current cache (when our dump is the same as the remote onb) or better to pull
# the new image (when it is different)
RUN head -c 30 /dev/urandom | xxd -ps >/build-cache-hash

# Link dumb-init for backwards compatibility (so that older images also work)
RUN ln -sf /usr/bin/dumb-init /usr/local/bin/dumb-init

# Install NPM dependencies here. The NPM dependencies don't change that often and we already have pip
# installed dependencies in case of CI optimised build, so it is ok to install NPM deps here
# Rather than after setup.py is added.
COPY airflow/www/yarn.lock airflow/www/package.json ${AIRFLOW_SOURCES}/airflow/www/

RUN yarn --cwd airflow/www install --frozen-lockfile --no-cache && yarn cache clean;

# Note! We are copying everything with airflow:airflow user:group even if we use root to run the scripts
# This is fine as root user will be able to use those dirs anyway.

# Airflow sources change frequently but dependency configuration won't change that often
# We copy setup.py and other files needed to perform setup of dependencies
# So in case setup.py changes we can install latest dependencies required.
COPY setup.py ${AIRFLOW_SOURCES}/setup.py
COPY setup.cfg ${AIRFLOW_SOURCES}/setup.cfg

COPY airflow/__init__.py ${AIRFLOW_SOURCES}/airflow/__init__.py

ARG UPGRADE_TO_LATEST_CONSTRAINTS="false"
ENV UPGRADE_TO_LATEST_CONSTRAINTS=${UPGRADE_TO_LATEST_CONSTRAINTS}

# The goal of this line is to install the dependencies from the most current setup.py from sources
# This will be usually incremental small set of packages in CI optimized build, so it will be very fast
# In non-CI optimized build this will install all dependencies before installing sources.
# Usually we will install versions based on the dependencies in setup.py and upgraded only if needed.
# But in cron job we will install latest versions matching setup.py to see if there is no breaking change
# and push the constraints if everything is successful
RUN if [[ ${INSTALL_FROM_PYPI} == "true" ]]; then \
        if [[ "${UPGRADE_TO_LATEST_CONSTRAINTS}" != "false" ]]; then \
            pip install --no-cache-dir -e ".[${AIRFLOW_EXTRAS}]" --upgrade --upgrade-strategy eager; \
        else \
            pip install --no-cache-dir -e ".[${AIRFLOW_EXTRAS}]" --upgrade --upgrade-strategy only-if-needed; \
        fi; else \
            pip install --no-cache-dir -e ".[${AIRFLOW_EXTRAS}]" --upgrade --upgrade-strategy only-if-needed; \
        fi \
    fi

# If wheel files are found in /docker-context-files during installation
# they are also installed additionally to whatever is installed from Airflow.
COPY docker-context-files/ /docker-context-files/

RUN if [[ ${INSTALL_FROM_DOCKER_CONTEXT_FILES} != "true" ]]; then \
        if ls /docker-context-files/*.{whl,tar.gz} 1> /dev/null 2>&1; then \
            pip install --no-cache-dir --no-deps /docker-context-files/*.{whl,tar.gz}; \
        fi; \
    fi

# Copy all the www/ files we need to compile assets. Done as two separate COPY
# commands so as otherwise it copies the _contents_ of static/ in to www/
COPY airflow/www/webpack.config.js ${AIRFLOW_SOURCES}/airflow/www/
COPY airflow/www/static ${AIRFLOW_SOURCES}/airflow/www/static/

# Package JS/css for production
RUN yarn --cwd airflow/www run prod

COPY scripts/in_container/entrypoint_ci.sh /entrypoint
RUN chmod a+x /entrypoint

# We can copy everything here. The Context is filtered by dockerignore. This makes sure we are not
# copying over stuff that is accidentally generated or that we do not need (such as egg-info)
# if you want to add something that is missing and you expect to see it in the image you can
# add it with ! in .dockerignore next to the airflow, test etc. directories there
COPY . ${AIRFLOW_SOURCES}/

# Install autocomplete for airflow
RUN if command -v airflow; then \
        register-python-argcomplete airflow >> ~/.bashrc ; \
    fi

# Install autocomplete for Kubectl
RUN echo "source /etc/bash_completion" >> ~/.bashrc

WORKDIR ${AIRFLOW_SOURCES}

# Install Helm
ARG HELM_VERSION="v3.2.4"

RUN SYSTEM=$(uname -s | tr '[:upper:]' '[:lower:]') \
    && HELM_URL="https://get.helm.sh/helm-${HELM_VERSION}-${SYSTEM}-amd64.tar.gz" \
    && curl -f --location "${HELM_URL}" | tar -xvz -O "${SYSTEM}"-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

# Additional python deps to install
ARG ADDITIONAL_PYTHON_DEPS=""

RUN if [[ -n "${ADDITIONAL_PYTHON_DEPS}" ]]; then \
        pip install --no-cache-dir ${ADDITIONAL_PYTHON_DEPS}; \
    fi

WORKDIR ${AIRFLOW_SOURCES}

ENV PATH="${HOME}:${PATH}"

# Needed to stop Gunicorn from crashing when /tmp is now mounted from host
ENV GUNICORN_CMD_ARGS="--worker-tmp-dir /dev/shm/"

ARG BUILD_ID
ENV BUILD_ID=${BUILD_ID}
ARG COMMIT_SHA
ENV COMMIT_SHA=${COMMIT_SHA}

LABEL org.apache.airflow.distro="debian" \
  org.apache.airflow.distro.version="buster" \
  org.apache.airflow.module="airflow" \
  org.apache.airflow.component="airflow" \
  org.apache.airflow.image="airflow-ci" \
  org.apache.airflow.version="${AIRFLOW_VERSION}" \
  org.apache.airflow.uid="0" \
  org.apache.airflow.gid="0" \
  org.apache.airflow.buildId=${BUILD_ID} \
  org.apache.airflow.commitSha=${COMMIT_SHA}

EXPOSE 8080

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint"]
