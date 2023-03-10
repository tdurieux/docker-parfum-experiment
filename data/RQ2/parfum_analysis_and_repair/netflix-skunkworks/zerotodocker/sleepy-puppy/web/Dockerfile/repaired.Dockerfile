# Copyright 2014 Netflix, Inc.
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

FROM ubuntu:14.04
MAINTAINER Netflix Open Source Development <talent@netflix.com>

RUN apt-get update && apt-get -y --no-install-recommends -q install python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 && apt-get install --no-install-recommends -y curl python-dev python-pip git sudo && apt-get -y --no-install-recommends -q install python-psycopg2 libpq-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/local/src &&\
  git clone --branch develop https://github.com/sbehrens/sleepy-puppy.git &&\
  cd sleepy-puppy &&\
  python setup.py install

ADD api-start.sh /usr/local/src/sleepy-puppy/scripts/api-start.sh
RUN chmod +x /usr/local/src/sleepy-puppy/scripts/api-start.sh

ENTRYPOINT ["/usr/local/src/sleepy-puppy/scripts/api-start.sh"]
