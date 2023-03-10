# Copyright 2018 Google LLC
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

# An image used to run a Python webserver that does compatibility checking
# between pip-installable packages.

# [START docker]
FROM gcr.io/google_appengine/python
ADD requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt
ADD . /app
ENTRYPOINT ["python3"]
CMD ["main.py"]
# [END docker]
