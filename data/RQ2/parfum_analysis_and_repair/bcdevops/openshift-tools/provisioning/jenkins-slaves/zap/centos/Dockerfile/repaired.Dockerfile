# This dockerfile builds the zap stable release
FROM centos:centos7
MAINTAINER Deven Phillips <deven.phillips@redhat.com>

RUN yum install -y epel-release && \
    yum clean all && rm -rf /var/cache/yum
RUN yum install -y redhat-rpm-config \
    make automake autoconf gcc gcc-c++ \
    libstdc++ libstdc++-devel \
    java-1.8.0-openjdk wget curl \
    xmlstarlet git x11vnc gettext tar \
    xorg-x11-server-Xvfb openbox xterm \
    net-tools python-pip \
    firefox nss_wrapper java-1.8.0-openjdk-headless \
    java-1.8.0-openjdk-devel nss_wrapper git && \
    yum clean all && rm -rf /var/cache/yum

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir zapcli
# Install latest dev version of the python API
RUN pip install --no-cache-dir python-owasp-zap-v2.4

RUN mkdir -p /zap/wrk
ADD zap /zap/

RUN mkdir -p /var/lib/jenkins/.vnc

# Copy the entrypoint
COPY configuration/* /var/lib/jenkins/
COPY configuration/run-jnlp-client /usr/local/bin/run-jnlp-client

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH $JAVA_HOME/bin:/zap:$PATH
ENV ZAP_PATH /zap/zap.sh
ENV HOME /var/lib/jenkins

# Default port for use with zapcli
ENV ZAP_PORT 8080

COPY policies /var/lib/jenkins/.ZAP/policies/
COPY .xinitrc /var/lib/jenkins/

WORKDIR /zap
# Download and expand the latest stable release
RUN curl -f -s https://raw.githubusercontent.com/zaproxy/zap-admin/master/ZapVersions-dev.xml | xmlstarlet sel -t -v //url | grep -i Linux | wget -q --content-disposition -i - -O - | tar zx --strip-components=1 && \
    curl -f -s -L https://bitbucket.org/meszarv/webswing/downloads/webswing-2.3-distribution.zip | jar -x && \
    touch AcceptedLicense
ADD webswing.config /zap/webswing-2.3/webswing.config

RUN chown -R root:root /zap && \
    chown -R root:root /var/lib/jenkins && \
    chmod -R 777 /var/lib/jenkins && \
    chmod -R 777 /zap && \
    chmod 777 /


WORKDIR /var/lib/jenkins

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/local/bin/run-jnlp-client"]
