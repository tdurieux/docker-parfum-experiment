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

  FROM 32bit/debian:jessie

  <%include file="../../apt_get_basic.include"/>
  <%include file="../../gcp_api_libraries.include"/>
  <%include file="../../python_deps.include"/>
  <%include file="../../cxx_deps.include"/>
  <%include file="../../run_tests_addons.include"/>
  <%include file="../../cmake_jessie_backports.include"/>

  # Install gcc-4.8 and other relevant items
  RUN apt-get update && apt-get -y --no-install-recommends install gcc-4.8 gcc-4.8-multilib g++-4.8 g++-4.8-multilib && apt-get clean && rm -rf /var/lib/apt/lists/*;

  # Define the default command.
  CMD ["bash"]
