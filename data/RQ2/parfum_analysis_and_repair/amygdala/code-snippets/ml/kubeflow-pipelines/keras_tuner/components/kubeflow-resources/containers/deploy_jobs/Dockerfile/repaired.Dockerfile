# Copyright 2020 Google Inc. All Rights Reserved.
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

FROM ubuntu:20.04

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev wget unzip \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

# RUN apt-get install -y wget unzip git

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir urllib3 certifi retrying
RUN pip install --no-cache-dir google-cloud-storage
RUN pip install --no-cache-dir --upgrade six


RUN wget -nv https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
    unzip -qq google-cloud-sdk.zip -d tools && \
    rm google-cloud-sdk.zip && \
    tools/google-cloud-sdk/install.sh --usage-reporting=false \
        --path-update=false --bash-completion=false \
        --disable-installation-options && \
    tools/google-cloud-sdk/bin/gcloud -q components update \
        gcloud core gsutil && \
    tools/google-cloud-sdk/bin/gcloud -q components install kubectl && \
    tools/google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check true && \
    touch /tools/google-cloud-sdk/lib/third_party/google.py


ENV PATH $PATH:/tools/google-cloud-sdk/bin

ADD build /ml

ENTRYPOINT ["python", "/ml/deploy_tuner.py"]

