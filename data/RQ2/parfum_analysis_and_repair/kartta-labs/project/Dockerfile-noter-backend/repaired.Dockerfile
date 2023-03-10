# Copyright 2015, Google, Inc.
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

# [START docker]

# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries. The source is on github at:
# https://github.com/GoogleCloudPlatform/python-docker

FROM nginx

RUN apt-get update && apt-get install --no-install-recommends -y \
        uwsgi-plugin-python3 \
        python3-venv \
        postgresql \
        postgresql-contrib \
        libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y







RUN useradd -ms /bin/bash kartta && \
    rm -f /etc/nginx/fastcgi.conf /etc/nginx/fastcgi_params && \
    rm -f /etc/nginx/snippets/fastcgi-php.conf /etc/nginx/snippets/snakeoil.conf

# Create a virtualenv.
RUN python3 -m venv env
ENV PATH /env/bin:$PATH

ADD ./noter-backend /noter-backend
RUN /env/bin/pip install --upgrade pip && /env/bin/pip install -r /noter-backend/requirements.txt

# COPY etc/ssl /etc/nginx/ssl
# COPY etc/snippets /etc/nginx/snippets
RUN mkdir /etc/nginx/sites-available
RUN mkdir /etc/nginx/sites-enabled
COPY ./noter-backend/etc/nginx.conf /etc/nginx/nginx.conf
COPY ./noter-backend/etc/noter.conf.template /etc/nginx/sites-available/noter.conf.template

# COPY etc/supervisord.conf /etc/supervisord.conf
# COPY etc/uwsgi.ini /etc/uwsgi/wsgi.ini
