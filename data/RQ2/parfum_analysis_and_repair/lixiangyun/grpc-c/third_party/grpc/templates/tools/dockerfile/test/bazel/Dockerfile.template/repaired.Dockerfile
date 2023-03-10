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

  FROM gcr.io/oss-fuzz-base/base-builder

  # Install basic packages and Bazel dependencies.
  RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
  RUN add-apt-repository ppa:webupd8team/java
  RUN apt-get update && apt-get -y install ${'\\'}
    autoconf ${'\\'}
    build-essential ${'\\'}
    curl ${'\\'}
    libtool ${'\\'}
    make ${'\\'}
    openjdk-8-jdk ${'\\'}
    vim

  <%include file="../../python_deps.include"/>

  <%include file="../../bazel.include"/>

  RUN mkdir -p /var/local/jenkins

  # Define the default command.
  CMD ["bash"]
