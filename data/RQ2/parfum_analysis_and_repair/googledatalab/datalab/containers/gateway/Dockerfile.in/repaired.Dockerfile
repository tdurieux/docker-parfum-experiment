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

FROM datalab-base
MAINTAINER Google Cloud DataLab

ADD content/ /datalab

# Install the support for running a kernel gateway
RUN pip install --no-cache-dir --upgrade-strategy only-if-needed jupyter_kernel_gateway

# Startup
ENV DATALAB_VERSION _version_
ENV DATALAB_COMMIT _commit_
ENTRYPOINT [ "/datalab/run.sh" ]
