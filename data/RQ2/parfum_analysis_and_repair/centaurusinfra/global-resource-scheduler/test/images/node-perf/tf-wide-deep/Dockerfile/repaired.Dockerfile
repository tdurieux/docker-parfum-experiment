# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM BASEIMAGE

CROSS_BUILD_COPY qemu-QEMUARCH-static /usr/bin/

RUN apt-get update && apt-get install --no-install-recommends -y wget time && rm -rf /var/lib/apt/lists/*;

RUN case $(uname -m) in \
    aarch64 \
      pip install --no-cache-dir tensorflow-aarch64; \
      ;; \
    * \
      pip install --no-cache-dir tensorflow; \
      ;; \
    esac

RUN wget https://github.com/tensorflow/models/archive/v1.9.0.tar.gz \
&& tar xzf v1.9.0.tar.gz \
&& rm -f v1.9.0.tar.gz

WORKDIR $HOME/models-1.9.0/official/wide_deep
ENV PYTHONPATH $PYTHONPATH:$HOME/models-1.9.0

ENTRYPOINT python ./wide_deep.py
