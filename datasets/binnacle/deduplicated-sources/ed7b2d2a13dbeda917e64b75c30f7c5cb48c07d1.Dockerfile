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

FROM arrow:cpp-alpine

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# better compatibility for the scripts
RUN apk add --no-cache coreutils

# install python, either python3(3.6) or python2(2.7)
ARG PYTHON_VERSION=3.6
RUN export PYTHON_MAJOR=${PYTHON_VERSION:0:1} && \
    apk add --no-cache python${PYTHON_MAJOR}-dev && \
    python${PYTHON_MAJOR} -m ensurepip && \
    ln -sf /usr/bin/pip${PYTHON_MAJOR} /usr/bin/pip && \
    ln -sf /usr/bin/python${PYTHON_MAJOR} /usr/bin/python && \
    pip install --upgrade pip setuptools

# install python requirements
COPY python/requirements.txt \
     python/requirements-test.txt \
     /arrow/python/
# pandas requires numpy at build time, so install the requirements separately
RUN pip install -r /arrow/python/requirements.txt cython && \
    pip install -r /arrow/python/requirements-test.txt

ENV ARROW_PYTHON=ON \
    PYARROW_WITH_ORC=0 \
    PYARROW_WITH_PARQUET=0

# build and test
CMD ["arrow/ci/docker_build_and_test_python.sh"]
