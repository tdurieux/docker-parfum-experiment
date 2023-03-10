# Copyright 2018 Google Inc. All Rights Reserved.
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

FROM ubuntu:16.04

RUN apt-get update -y && apt-get install --no-install-recommends -y -q ca-certificates python-dev python-setuptools wget unzip git && rm -rf /var/lib/apt/lists/*;

RUN easy_install pip

RUN pip install --no-cache-dir pyyaml==3.12 six==1.11.0 requests==2.18.4 tensorflow==1.10.0 \
      kubernetes google-api-python-client retrying
RUN pip install --no-cache-dir google-cloud-storage

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

RUN wget -nv https://github.com/ksonnet/ksonnet/releases/download/v0.13.1/ks_0.13.1_linux_amd64.tar.gz && \
    tar -xvzf ks_0.13.1_linux_amd64.tar.gz && \
    mkdir -p /tools/ks/bin && \
    cp ./ks_0.13.1_linux_amd64/ks /tools/ks/bin && \
    rm ks_0.13.1_linux_amd64.tar.gz && \
    rm -r ks_0.13.1_linux_amd64

RUN wget https://github.com/kubeflow/tf-operator/archive/v0.4.0-rc.1.zip && \
    unzip v0.4.0-rc.1.zip && \
    mv tf-operator-0.4.0-rc.1 tf-operator

ENV PYTHONPATH $PYTHONPATH:/tf-operator

RUN wget https://github.com/kubeflow/testing/archive/master.zip && \
    unzip master.zip && \
    mv testing-master testing

ENV PYTHONPATH $PYTHONPATH:/testing/py

ENV PATH $PATH:/tools/google-cloud-sdk/bin:/tools/ks/bin

ADD build /ml

ENTRYPOINT ["python", "/ml/train.py"]

