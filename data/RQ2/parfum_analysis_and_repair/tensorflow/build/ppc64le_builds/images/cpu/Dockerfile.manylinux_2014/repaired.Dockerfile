#docker build -f Dockerfile.manylinux_2014 -t ibmcom/tensorflow-ppc64le:devel-manylinux2014 .
FROM quay.io/pypa/manylinux2014_ppc64le

ARG BAZEL_VERSION=3.7.2
ENV PATH=/opt/python/cp36-cp36m/bin:$PATH

RUN yum install -y java-11-openjdk-devel wget zip && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-dist.zip && \
    unzip bazel-$BAZEL_VERSION-dist.zip && \
    BAZEL_LINKLIBS=-l%:libstdc++.a EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh && \
    cp output/bazel /usr/local/bin/ && \
    cd / && \
    rm -rf /bazel

RUN pip install --no-cache-dir six numpy wheel setuptools mock
RUN pip install --no-cache-dir keras_applications keras_preprocessing --no-deps

#To build in OSU's Jenkins environment
#From https://github.com/osuosl/osl-dockerfiles/blob/master/centos-ppc64le/Dockerfile#L14-L31
ARG user=jenkins
ARG group=jenkins
ARG uid=10000
ARG gid=10000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

RUN groupadd -g ${gid} ${group} && \
    useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

# setup sudo
RUN yum install -y sudo && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
