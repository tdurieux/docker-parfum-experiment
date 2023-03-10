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

  FROM debian:jessie

  <%include file="../../apt_get_basic.include"/>
  <%include file="../../gcp_api_libraries.include"/>
  <%include file="../../python_deps.include"/>
  <%include file="../../cxx_deps.include"/>
  <%include file="../../cmake_jessie_backports.include"/>
  <%include file="../../clang_update.include"/>
  <%include file="../../run_tests_addons.include"/>
  RUN clang++ -c -g -O2 -std=c++11 llvm/lib/Fuzzer/*.cpp -IFuzzer
  RUN ar ruv libFuzzer.a Fuzzer*.o
  RUN mv libFuzzer.a /usr/lib
  RUN rm -f Fuzzer*.o
  # Define the default command.
  CMD ["bash"]