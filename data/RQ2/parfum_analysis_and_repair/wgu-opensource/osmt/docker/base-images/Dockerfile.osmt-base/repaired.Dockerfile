FROM centos:centos8.3.2011 as osmt-base

LABEL Maintainer="WGU / OSN"

ENV JAVA_HOME=/etc/alternatives/jre
ENV USER=osmt
ENV BASE_DIR=/opt/${USER}

# Install EPEL / Useful packages /
RUN /usr/bin/yum install -y epel-release \
    && /usr/bin/yum update -y \
    && /usr/bin/yum remove -y java-1.8.0-openjdk* \
    && /usr/bin/yum install -y curl java-11-openjdk wget

# Add in configuration files
ADD etc /etc

# Set a DNS lookup TTL to 10 seconds
RUN sed -i 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/' ${JAVA_HOME}/conf/security/java.security

# Create user
RUN /usr/sbin/useradd -r -d ${BASE_DIR} -s /bin/bash ${USER} -k /etc/skel -m -U \
    && mkdir -p ${BASE_DIR}/bin ${BASE_DIR}/build ${BASE_DIR}/logs ${BASE_DIR}/etc \
    && chown -R ${USER}:${USER} ${BASE_DIR}