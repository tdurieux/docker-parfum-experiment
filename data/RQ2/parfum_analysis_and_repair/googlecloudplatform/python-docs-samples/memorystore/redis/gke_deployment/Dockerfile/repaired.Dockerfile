# Copyright 2021 Google LLC
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

# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries. The source is on github at:
#   https://github.com/GoogleCloudPlatform/python-docker
FROM gcr.io/google_appengine/python

# Create a virtualenv for the application dependencies.
# If you want to use Python 2, add the -p python2.7 flag.
RUN virtualenv -p python3.4 /env

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate. This ensures the application is executed within
# the context of the virtualenv and will have access to its dependencies.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# Note: REDISHOST value here is only used for local testing
# See README.md on how to inject environment variable as ConfigMap on GKE
ENV REDISHOST 127.0.0.1
ENV REDISPORT 6379

# Install dependencies.
ADD requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Add application code.
ADD . /app

CMD ["gunicorn", "-b", "0.0.0.0:8080", "main:app"]

