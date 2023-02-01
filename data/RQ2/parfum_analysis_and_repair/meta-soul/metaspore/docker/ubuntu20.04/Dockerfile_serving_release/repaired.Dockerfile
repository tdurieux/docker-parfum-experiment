#
# Copyright 2022 DMetaSoul
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
#
ARG BUILD_IMAGE
ARG RUNTIME=cpu
FROM nvidia/cuda:11.6.2-cudnn8-runtime-ubuntu20.04 as serving_gpu_base
FROM ubuntu:20.04 as serving_cpu_base

FROM serving_${RUNTIME}_base as serving_base
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "deb http://repo.huaweicloud.com/ubuntu/ focal main restricted" >/etc/apt/sources.list
RUN echo "deb http://repo.huaweicloud.com/ubuntu/ focal-updates main restricted" >>/etc/apt/sources.list
RUN echo "deb http://repo.huaweicloud.com/ubuntu/ focal universe" >>/etc/apt/sources.list
RUN echo "deb http://repo.huaweicloud.com/ubuntu/ focal-updates universe" >>/etc/apt/sources.list
RUN echo "deb http://repo.huaweicloud.com/ubuntu/ focal multiverse" >>/etc/apt/sources.list
RUN echo "deb http://repo.huaweicloud.com/ubuntu/ focal-updates multiverse" >>/etc/apt/sources.list
RUN echo "deb http://repo.huaweicloud.com/ubuntu/ focal-backports main restricted universe multiverse" >>/etc/apt/sources.list
RUN echo "deb http://repo.huaweicloud.com/ubuntu focal-security main restricted" >>/etc/apt/sources.list
RUN echo "deb http://repo.huaweicloud.com/ubuntu focal-security multiverse" >>/etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install --no-install-recommends -y locales && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=Asia/Shanghai
RUN ln -svf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && apt-get install --no-install-recommends -y tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends --fix-missing -y python3 python3-setuptools python3-venv ca-certificates && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 30
RUN python -m easy_install install pip
RUN python -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
RUN python -m pip install grpcio-tools numpy pyarrow --no-cache-dir

FROM ${BUILD_IMAGE} as build_stage

FROM serving_base as serving_release
COPY --from=build_stage /opt/metaspore-serving/ /opt/metaspore-serving
COPY --from=build_stage /opt/metaspore-build-release/libonnxruntime* /opt/metaspore-serving/bin/
COPY --from=build_stage /opt/metaspore-build-release/libstdc++.so* /opt/metaspore-serving/bin/
COPY --from=build_stage /opt/metaspore-build-release/libgcc_s.so* /opt/metaspore-serving/bin/

FROM serving_base as serving_debug
RUN apt-get install --no-install-recommends -y gdb vim python3 && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=build_stage /opt/metaspore/debug/metaspore-serving-bin.debug /opt/metaspore/debug/metaspore-serving-bin.debug
