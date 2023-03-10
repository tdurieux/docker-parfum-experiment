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
RUN apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl software-properties-common python2.7 python3.6 python-pip python3-pip supervisor && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;

# install python dependencies
COPY requirements.txt requirements.txt
COPY requirements_dev.txt requirements_dev.txt
RUN pip install --no-cache-dir -Ur requirements_dev.txt
RUN pip3 install --no-cache-dir -Ur requirements_dev.txt

# copy in the library
COPY aws_lambda_fsm aws_lambda_fsm
COPY tools tools
COPY examples examples
COPY setup.py setup.py
COPY fsm.yaml fsm.yaml

COPY tests/functional/settings.py.functional settings.py
COPY tests/functional/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

ENV AWS_DEFAULT_REGION=testing
ENV AWS_ACCESS_KEY_ID=abc123
ENV AWS_SECRET_ACCESS_KEY=abc123

RUN mkdir -p ~/.aws
RUN echo "[default]" > ~/.aws/credentials
RUN echo "aws_access_key_id = abc123" >> ~/.aws/credentials
RUN echo "aws_secret_access_key = abc123" >> ~/.aws/credentials

# use supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisor.conf", "-l", "/dev/null", "-y", "0"]
