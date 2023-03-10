# Copyright 2020 Google Inc. All rights reserved.
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


# Start with a base Python 3.8 image
FROM python:3.8

WORKDIR /home

# Install the required dependencies via pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy tasks and runner script
COPY run.sh .
COPY *.py ./
COPY locust_tasks ./locust_tasks

# Expose the required Locust ports
# - Master Port: 5557 (client locust), 5558 (SRE Recipe locust)
# - Web UI Port: 8089 (client locust), 8090 (SRE Recipe locust)
EXPOSE 5557 5558 8089 8090

# Start Locust using LOCUS_OPTS environment variable
ENTRYPOINT ["./run.sh"]
