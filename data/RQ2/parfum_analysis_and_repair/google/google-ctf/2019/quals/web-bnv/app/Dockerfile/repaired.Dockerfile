# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM gcr.io/google-appengine/python

# Create a virtualenv for dependencies. This isolates these packages from
# system-level packages.
RUN virtualenv /env -p python2.7

# Setting these environment variables are the same as running
# source /env/bin/activate.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# Copy the application's requirements.txt and run pip to install all
# dependencies into the virtualenv.
ADD requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt
RUN apt-get update
RUN apt-get install --no-install-recommends -y -q libreoffice && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q yelp && rm -rf /var/lib/apt/lists/*;

# Add the application source code.
ADD . /app

# Run a WSGI server to serve the application. gunicorn must be declared as
# a dependency in requirements.txt.
CMD gunicorn -b :$PORT main:app