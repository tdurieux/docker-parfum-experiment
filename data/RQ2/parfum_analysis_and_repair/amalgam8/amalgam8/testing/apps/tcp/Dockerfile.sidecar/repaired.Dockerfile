# Copyright 2016 IBM Corporation
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM amalgam8/a8-sidecar:latest

ADD app.py /opt/microservices/
ADD test.py /opt/microservices/
WORKDIR /opt/microservices

EXPOSE 1111

RUN apt-get install --no-install-recommends -yqq python && rm -rf /var/lib/apt/lists/*;
CMD ["python", "/opt/microservices/app.py"]
