# Copyright 2019 The Johns Hopkins University Applied Physics Laboratory
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

#Use an official Python runtime as a parent image
FROM python:3

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir scikit-image
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir scipy

RUN mkdir /app
COPY --chown=1000:100 normalize /app/
ENV PATH /app:$PATH
WORKDIR /app

