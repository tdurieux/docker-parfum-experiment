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
ARG SPARK_RELEASE="tarball"
ARG METASPORE_RELEASE="http"
ARG METASPORE_BUILD_IMAGE="metaspore-training-build:v1.0.0"
ARG INSTALL_SPARK_CLOUD="false"

FROM ubuntu:20.04 as env

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
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=Asia/Shanghai
RUN ln -svf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3.8 python3-setuptools ca-certificates maven vim sudo curl wget git libgomp1 && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME=/usr

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 30
RUN python -m easy_install install pip
RUN python -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

RUN apt-get install --no-install-recommends -y pkg-config uuid-dev libpulse-dev && \
    apt-get install --no-install-recommends -y tini libpam-modules krb5-user libnss3 procps && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && rm -rf /var/lib/apt/lists/*;

RUN python -m pip install --upgrade pip setuptools wheel && \
    python -m pip install numpy && \
    python -m pip install torch==1.11.0+cpu torchvision==0.12.0+cpu torchaudio==0.11.0+cpu \
     -f https://download.pytorch.org/whl/cpu/torch_stable.html && \
    python -m pip install awscli awscli-plugin-endpoint && \
    python -m pip install onnx onnxmltools onnxruntime xgboost lightgbm tabulate && \
    python -m pip install pymilvus faiss-cpu && \
    python -m pip install https://github.com/sllynn/spark-xgboost/releases/download/v0.9/spark_xgboost-0.90-py3-none-any.whl && \
    python -m pip cache purge && \
    echo OK: python

FROM env as metaspore_http_install
ARG METASPORE_WHEEL="https://ks3-cn-beijing.ksyuncs.com/dmetasoul-bucket/releases/metaspore/metaspore-1.0.0%2B48beee4-cp38-cp38-linux_x86_64.whl"
RUN python -m pip install ${METASPORE_WHEEL} && pip cache purge

FROM ${METASPORE_BUILD_IMAGE} as metaspore_build_install
FROM env as metaspore_build_install
COPY --from=metaspore_build /opt/metaspore-build-release/metaspore-*.whl .
RUN python -m pip install metaspore-*.whl && pip cache purge && rm -f metaspore-*.whl

FROM metaspore_${METASPORE_RELEASE}_install as spark-tarball-install
ARG SPARK_FILE="https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz"
ARG SYNAPSEML_VERSION="0.9.5-92-76c32ccf-SNAPSHOT"
RUN mkdir -p /opt/spark && wget ${SPARK_FILE} && tar xf `basename ${SPARK_FILE}` -C /opt/spark --strip-components 1 && rm -f `basename ${SPARK_FILE}`
ENV SPARK_HOME /opt/spark
ENV SPARK_CONF_DIR /opt/spark/conf
ENV PATH=$SPARK_HOME/bin:$PATH
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/jars/synapseml_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-cognitive_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-core_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-deep-learning_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-lightgbm_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-opencv_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-vw_2.12-${SYNAPSEML_VERSION}.jar:$PYTHONPATH
COPY docker/ubuntu20.04/release-copy-deps-pom.xml docker/ubuntu20.04/maven-proxy-settings.xml .
ARG MAVEN_OPTS="-Xmx4g -XX:ReservedCodeCacheSize=1g"
ENV MAVEN_OPTS=${MAVEN_OPTS}
RUN mvn -f release-copy-deps-pom.xml -s maven-proxy-settings.xml dependency:copy-dependencies -Dsynapseml.version=$SYNAPSEML_VERSION -DskipTests -Dmaven.test.skip=true -Dactivate.spark-hadoop-cloud=${INSTALL_SPARK_CLOUD} -DoutputDirectory=${SPARK_HOME}/jars && rm -rf ~/.m2 maven-proxy-settings.xml release-copy-deps-pom.xml
ENV MAVEN_OPTS=

FROM metaspore_${METASPORE_RELEASE}_install as spark-pyspark-install
ARG SPARK_FILE="pyspark"
ARG SYNAPSEML_VERSION="0.9.5-92-76c32ccf-SNAPSHOT"
RUN python -m pip install ${SPARK_FILE}
ENV SPARK_HOME /usr/local/lib/python3.8/dist-packages/pyspark
RUN mkdir -p /opt/spark/conf
ENV SPARK_CONF_DIR /opt/spark/conf
ENV PATH=$SPARK_HOME/bin:$PATH
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/jars/synapseml_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-cognitive_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-core_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-deep-learning_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-lightgbm_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-opencv_2.12-${SYNAPSEML_VERSION}.jar:$SPARK_HOME/jars/synapseml-vw_2.12-${SYNAPSEML_VERSION}.jar:$PYTHONPATH
COPY docker/ubuntu20.04/release-copy-deps-pom.xml docker/ubuntu20.04/maven-proxy-settings.xml .
ARG MAVEN_OPTS="-Xmx4g -XX:ReservedCodeCacheSize=1g"
ENV MAVEN_OPTS=${MAVEN_OPTS}
RUN mvn -f release-copy-deps-pom.xml -s maven-proxy-settings.xml dependency:copy-dependencies -Dsynapseml.version=$SYNAPSEML_VERSION -DskipTests -Dmaven.test.skip=true -Dactivate.spark-hadoop-cloud=${INSTALL_SPARK_CLOUD} -DoutputDirectory=${SPARK_HOME}/jars && rm -rf ~/.m2 maven-proxy-settings.xml release-copy-deps-pom.xml
ENV MAVEN_OPTS=

FROM spark-${SPARK_RELEASE}-install as release