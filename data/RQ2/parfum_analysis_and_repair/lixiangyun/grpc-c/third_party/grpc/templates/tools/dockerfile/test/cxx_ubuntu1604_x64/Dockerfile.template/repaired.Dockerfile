%YAML 1.2
--- |
  # Copyright 2015 gRPC authors.
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

  FROM ubuntu:16.04

  <%include file="../../apt_get_basic.include"/>
  <%include file="../../gcp_api_libraries.include"/>
  <%include file="../../python_deps.include"/>
  <%include file="../../cxx_deps.include"/>
  <%include file="../../run_tests_addons.include"/>

  # The clang-3.6 symlink for the default clang version was added
  # to Ubuntu 16.04 recently, so make sure it's installed.
  # Also install clang3.7.
  RUN apt-get update && apt-get -y --no-install-recommends install clang-3.6 clang-3.7 && apt-get clean && rm -rf /var/lib/apt/lists/*;

  # Define the default command.
  CMD ["bash"]
