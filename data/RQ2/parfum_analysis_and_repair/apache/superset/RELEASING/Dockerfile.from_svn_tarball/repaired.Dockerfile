#
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
FROM python:3.8-buster

RUN useradd --user-group --create-home --no-log-init --shell /bin/bash superset

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update -y

# Install dependencies to fix `curl https support error` and `elaying package configuration warning`
RUN apt-get install --no-install-recommends -y apt-transport-https apt-utils && rm -rf /var/lib/apt/lists/*;

# Install superset dependencies
# https://superset.apache.org/docs/installation/installing-superset-from-scratch
RUN apt-get install --no-install-recommends -y build-essential libssl-dev \
    libffi-dev python3-dev libsasl2-dev libldap2-dev libxi-dev && rm -rf /var/lib/apt/lists/*;

# Install nodejs for custom build
# https://nodejs.org/en/download/package-manager/
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/superset
RUN chown superset /home/superset

WORKDIR /home/superset
ARG VERSION

# Can fetch source from svn or copy tarball from local mounted directory
RUN svn co https://dist.apache.org/repos/dist/dev/superset/$VERSION ./
RUN tar -xvf *.tar.gz && rm *.tar.gz
WORKDIR apache-superset-$VERSION

RUN cd superset-frontend \
    && npm ci \
    && npm run build \
    && rm -rf node_modules


WORKDIR /home/superset/apache-superset-$VERSION
RUN pip install --no-cache-dir --upgrade setuptools pip \
    && pip install --no-cache-dir -r requirements/base.txt \
    && pip install --no-cache-dir .

RUN flask fab babel-compile --target superset/translations

ENV PATH=/home/superset/superset/bin:$PATH \
    PYTHONPATH=/home/superset/superset/:$PYTHONPATH
COPY from_tarball_entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
