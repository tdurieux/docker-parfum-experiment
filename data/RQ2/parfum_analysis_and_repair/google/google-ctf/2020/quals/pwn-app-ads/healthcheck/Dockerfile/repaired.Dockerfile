# Copyright 2020 Google LLC
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

FROM python:3.6-alpine

RUN set -e -x ; \
        apk add --no-cache gcc python3-dev musl-dev ; \
        pip install --no-cache-dir nameko

RUN set -e -x ;\
        mkdir /app ;\
        adduser -S app

ADD config.yaml /app/
ADD healthcheck.py /app/

RUN set -e -x ;\
        chown -R app /app

USER app
WORKDIR /app
EXPOSE 5000
CMD nameko run --config config.yaml healthcheck
