# Copyright 2020 The Merlin Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM continuumio/miniconda3

RUN apt-get -qq update \
&& apt-get -y --no-install-recommends install vim make wget curl \
&& conda install -c conda-forge pandoc=1.19.2 && rm -rf /var/lib/apt/lists/*;

COPY . /tmp/merlin-sdk
WORKDIR /tmp/merlin-sdk/docs

RUN pip install --no-cache-dir -r requirements_docs.txt \
&& make html


FROM node:13-stretch
RUN npm install -g serve && npm cache clean --force;
COPY --from=0 /tmp/merlin-sdk/docs/_build /opt/merlin-docs
COPY --from=0 /tmp/merlin-sdk/docs/serve.json /opt/merlin-docs/html/serve.json

WORKDIR  /opt/merlin-docs

CMD ["serve", "html"]