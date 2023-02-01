# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM google/dev-common

ADD package.json /app/
ADD server.js /app/
ADD index.html /app/
ADD start.sh /
RUN chmod a+rx /start.sh
ADD supervisord.conf /etc/supervisord.conf
COPY ./codiad.tgz.part.* /app/

WORKDIR /app
RUN npm install

EXPOSE 8080

ENV ONRUN $ONRUN "bash /start.sh"
