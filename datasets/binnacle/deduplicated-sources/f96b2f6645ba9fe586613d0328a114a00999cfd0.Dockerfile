# Copyright 2015 Google Inc. All rights reserved.
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

FROM _base_image_
MAINTAINER Google Cloud DataLab

# Add build artifacts
ADD build/web/nb /datalab/web
ADD content/ /datalab

# Install the build artifacts
RUN ln -s /datalab/web/static/datalab.css /datalab/nbconvert/datalab.css && \
    cd /datalab/web && /tools/node/bin/npm install && \
    mv /datalab/.bashrc /root/.bashrc && \
    cd / && \
# Install ungit
    /tools/node/bin/npm install -g ungit@1.1.0 && \
    /tools/node/bin/npm install -s chokidar@1.6.1

# Startup
ENV ENV /root/.bashrc
ENV SHELL /bin/bash
ENV DATALAB_VERSION _version_
ENV DATALAB_COMMIT _commit_
ENV ENABLE_USAGE_REPORTING true

# Startup
ENTRYPOINT [ "/datalab/run.sh" ]
