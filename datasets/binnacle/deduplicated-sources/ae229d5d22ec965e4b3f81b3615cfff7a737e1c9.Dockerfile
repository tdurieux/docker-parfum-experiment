# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM arrow:python-3.6

RUN apt-get update && \
    apt-get install -y -q \
      clang-7 \
      libclang-7-dev \
      clang-format-7 \
      clang-tidy-7 \
      clang-tools-7

RUN conda install flake8 && \
    conda clean --all -y

ENV PATH=/opt/iwyu/bin:$PATH
ADD ci/docker_install_iwyu.sh /arrow/ci/
RUN arrow/ci/docker_install_iwyu.sh