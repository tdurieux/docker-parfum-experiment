# Copyright IBM Corporation 2019.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Description:
#    This Dockerfile.test is for running the csi controller local tests inside a container.
#    Its similar to the Dockerfile, but with additional requirements-tests.txt and ENTRYPOINT to run the local tests.

FROM registry.access.redhat.com/ubi8/python-38:1-75.1638364053 as builder
USER root
RUN if [[ "$(uname -m)" != "x86"* ]]; then \
 yum install -y rust-toolset; rm -rf /var/cache/yumfi
USER default
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
RUN pip3 install --no-cache-dir --ignore-installed --default-timeout=100 --upgrade pip==21.2.4
WORKDIR /tmp
COPY controllers/servers/csi/requirements.txt ./csi_requirements.txt
COPY controllers/servers/host_definer/requirements.txt ./host_definer_requirements.txt
# avoid default- boringssl lib, since it does not support z systems
ENV GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=True
RUN pip3 install --no-cache-dir -r ./csi_requirements.txt -r

USER root
COPY controllers/scripts/csi_general .
RUN ./csi_pb2.sh
RUN pip3 install --no-cache-dir .

# Requires to run local testing
COPY controllers/tests/requirements.txt ./requirements-tests.txt
RUN pip3 install --no-cache-dir -r ./requirements-tests.txt


FROM registry.access.redhat.com/ubi8/python-38:1-100

COPY --from=builder /opt/app-root /opt/app-root
COPY ./common /driver/common
COPY ./controllers/ /driver/controllers/
USER root
RUN groupadd -g 9999 appuser && \
    useradd -r -u 9999 -g appuser appuser
RUN chown -R appuser:appuser /driver /opt/app-root
USER appuser
WORKDIR /driver
ENV PYTHONPATH=/driver

ENTRYPOINT ["/driver/controllers/scripts/entrypoint-test.sh"]
