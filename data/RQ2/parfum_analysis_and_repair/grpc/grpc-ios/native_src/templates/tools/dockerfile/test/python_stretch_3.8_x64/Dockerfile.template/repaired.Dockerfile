%YAML 1.2
--- |
  # Copyright 2019 The gRPC Authors
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

  <%include file="../../python_stretch_base.include"/>
  <%include file="../../compile_python_38.include"/>

  RUN ln -s $(which python3.8) /usr/bin/python3

  <%include file="../../gcp_api_libraries.include"/>