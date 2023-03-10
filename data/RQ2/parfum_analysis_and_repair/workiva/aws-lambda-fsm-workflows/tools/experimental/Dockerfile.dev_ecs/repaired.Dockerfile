# Copyright 2016-2020 Workiva Inc.
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

FROM ubuntu:bionic

# apt stuff
RUN apt-get update
RUN apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl software-properties-common python2.7 python3.6 python-pip python3-pip && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;

# copy and build
COPY aws_lambda_fsm aws_lambda_fsm
COPY tools tools
COPY requirements.txt requirements.txt
COPY requirements_dev.txt requirements_dev.txt
COPY setup.py setup.py
COPY tests/functional/settings.py.functional settings.py
COPY tools/experimental/dev_ecs.py dev_ecs.py

# install python stuff
RUN pip install --no-cache-dir -Ur requirements_dev.txt
RUN pip install --no-cache-dir docker-py==1.8.1
RUN python setup.py install
RUN pip3 install --no-cache-dir -Ur requirements_dev.txt
RUN pip3 install --no-cache-dir docker-py==1.8.1
RUN python3 setup.py install

# set the cmd
CMD ["/bin/bash", "-c", "${PYTHON_BIN} dev_ecs.py --image=fsm_docker_runner:latest"]

