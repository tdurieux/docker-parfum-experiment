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

FROM nginx:1.7.7
MAINTAINER Netflix Open Source Development <talent@netflix.com>

RUN apt-get update &&\
  apt-get install -y curl git sudo apt-transport-https &&\
  cd /usr/local/src &&\
  git clone -b v0.3.4 https://github.com/Netflix/security_monkey.git &&\
  cd security_monkey

RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - &&\
  curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
  apt-get update &&\
  apt-get install -y -q dart

RUN cd /usr/local/src/security_monkey/dart &&\
  /usr/lib/dart/bin/pub build &&\
  /bin/mkdir -p /usr/local/src/security_monkey/security_monkey/static/ &&\
  /bin/cp -R /usr/local/src/security_monkey/dart/build/web/* /usr/local/src/security_monkey/security_monkey/static/

RUN /bin/mkdir -p /var/log/security_monkey/ &&\
  /usr/bin/touch /var/log/security_monkey/security_monkey.access.log &&\
  /usr/bin/touch /var/log/security_monkey/security_monkey.error.log

EXPOSE 443

ADD securitymonkey.conf /etc/nginx/sites-available/securitymonkey.conf
COPY nginx.conf /etc/nginx/nginx.conf
ADD server.crt /etc/nginx/ssl/
ADD server.key /etc/nginx/ssl/

RUN /bin/mkdir -p /etc/nginx/sites-enabled/ &&\
  ln -s /etc/nginx/sites-available/securitymonkey.conf /etc/nginx/sites-enabled/securitymonkey.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]

