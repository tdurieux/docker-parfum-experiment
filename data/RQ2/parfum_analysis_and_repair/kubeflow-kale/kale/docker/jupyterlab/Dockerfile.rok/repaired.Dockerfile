#  Copyright 2020 The Kale Authors
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# Use tensorflow-1.14.0 based image with Rok as a base image
FROM gcr.io/arrikto-public/tensorflow-1.14.0-notebook-cpu:kubecon-workshop

USER root

RUN echo 'alias grep="grep --color=auto' >> /etc/bash.bashrc && \
    echo 'alias ls="ls --color=auto' >> /etc/bash.bashrc

# Install latest KFP SDK & Kale & JupyterLab Extension
RUN pip3 install --no-cache-dir --upgrade pip && \
    # XXX: Install enum34==1.1.8 because other versions lead to errors during
    #  KFP installation
    pip3 install --no-cache-dir --upgrade "enum34==1.1.8" && \
    pip3 install --no-cache-dir --upgrade "jupyterlab>=2.0.0,<3.0.0" && \
    pip3 install --no-cache-dir --upgrade kubeflow-kale && \
    jupyter labextension install kubeflow-kale-labextension

RUN echo "jovyan ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/jovyan
WORKDIR /home/jovyan
USER jovyan

CMD ["sh", "-c", \
     "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser \
      --allow-root --port=8888 --LabApp.token='' --LabApp.password='' \
      --LabApp.allow_origin='*' --LabApp.base_url=${NB_PREFIX}"]
