# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM gcr.io/clusterfuzz-images/base

# Use nodesource nodejs packages.
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

# TOOD(ochang):Also need libnss3 libfreetype6 libfontconfig1 libgconf-2-4 xvfb for chrome-driver.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        git \
        golang-go \
        google-cloud-sdk-app-engine-go \
        google-cloud-sdk-app-engine-python \
        google-cloud-sdk-app-engine-python-extras \
        google-cloud-sdk-datastore-emulator \
        google-cloud-sdk-pubsub-emulator=312.0.0-0 \
        liblzma-dev \
        nodejs \
        openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# Install Bazel as per https://docs.bazel.build/versions/master/install-ubuntu.html#using-bazel-custom-apt-repository.
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl -f https://storage.googleapis.com/www.bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y bazel && rm -rf /var/lib/apt/lists/*;

RUN npm install -g bower polymer-bundler && npm cache clean --force;

# Install latest Chrome stable, needed for chromedriver testing.
RUN curl -f -s https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# Container Builder mount.
VOLUME /workspace
WORKDIR /workspace

ENV BOT_TMPDIR /tmp
ENV ROOT_DIR /workspace
ENV PYTHONPATH $ROOT_DIR/src

ENV TEST_BOT_ENVIRONMENT 1
ENV PYTHONDONTWRITEBYTECODE 1

COPY setup deploy /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*

# The ClusterFuzz checkout is typically mounted in with a different owner UID.
RUN git config --global --add safe.directory /workspace
