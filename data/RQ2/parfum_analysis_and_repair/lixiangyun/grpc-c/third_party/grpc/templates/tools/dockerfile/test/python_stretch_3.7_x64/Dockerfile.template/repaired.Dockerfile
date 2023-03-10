%YAML 1.2
--- |
  # Copyright 2018 The gRPC Authors
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

  <%include file="../../python_stretch.include"/>

  RUN apt-get update && apt-get -t testing --no-install-recommends install -y python3.7 python3-all-dev && rm -rf /var/lib/apt/lists/*;
  RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.7
