# Copyright (c) 2018 Intel Corporation
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

#### Multistage Dockerfile
# to build wca in three flavors:
# 1. devel: development version (without version)
# 2. pex: pex based Dockerfile that includes version number based on .git repo
# 3. standalone: empty image with just and not any development tools

## Testing
# 1. Build
# docker build -t wca:latest .

# 2. Run
# sudo docker run -it --privileged --rm wca -c /wca/configs/extra/static_measurements.yaml -0
# should output some metrics

# ------------------------ devel ----------------------
FROM centos:7 AS devel

RUN yum -y update && yum -y install python36 python-pip which make git wget

# The official way to build impctl is used below,
# based on instruction from https://github.com/intel/ipmctl#build,
# where ndctl, libsafec is dependency of ipmctl
WORKDIR /etc/yum.repos.d
RUN wget https://copr.fedorainfracloud.org/coprs/jhli/ipmctl/repo/epel-7/jhli-ipmctl-epel-7.repo
RUN wget https://copr.fedorainfracloud.org/coprs/jhli/safeclib/repo/epel-7/jhli-safeclib-epel-7.repo
RUN yum install -y ndctl ndctl-libs ndctl-devel libsafec ipmctl dmidecode
# --- TODO: consider moving that to init container just responsible for preparing this data

WORKDIR /wca


ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8


# note: Cache will be propably invalidated here.
COPY configs ./configs

COPY examples/external_package.py ./examples
COPY examples/hello_world_runner.py ./examples
COPY examples/hello_world_runner_with_dateutil.py ./examples
COPY examples/http_storage.py ./examples
COPY examples/__init__.py ./examples
COPY Makefile .
COPY requirements.txt .

RUN make venv

ENV PYTHONPATH=/wca

COPY wca ./wca

ENTRYPOINT ["/wca/env/bin/python", "wca/main.py"]

# ------------------------ pex ----------------------
# "pex" stage includes pex file in /usr/bin/
FROM devel AS pex
COPY . .
RUN make clean
RUN make venv
RUN make wca_package
RUN cp /wca/dist/wca.pex /usr/bin/
ENTRYPOINT ["/usr/bin/wca.pex"]

## ------------------------ standalone ----------------------
## Building final container that consists of wca only.
FROM centos:7 AS standalone
RUN yum -y install python36 which wget
# The official way to build impctl is used below,
# based on instruction from https://github.com/intel/ipmctl#build,
# where ndctl, libsafec is dependency of ipmctl
WORKDIR /etc/yum.repos.d
RUN wget https://copr.fedorainfracloud.org/coprs/jhli/ipmctl/repo/epel-7/jhli-ipmctl-epel-7.repo
RUN wget https://copr.fedorainfracloud.org/coprs/jhli/safeclib/repo/epel-7/jhli-safeclib-epel-7.repo
RUN yum install -y ndctl ndctl-libs ndctl-devel libsafec ipmctl dmidecode
COPY --from=pex /wca/dist/wca.pex /usr/bin/
ENTRYPOINT ["/usr/bin/wca.pex"]
