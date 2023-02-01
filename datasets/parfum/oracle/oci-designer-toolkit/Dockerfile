
# Copyright (c) 2020, 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

FROM oraclelinux:7-slim
ARG BRANCH=master
LABEL "provider"="Oracle" \
      "issues"="https://github.com/oracle/oci-designer-toolkit/issues" \
      "version"="0.38.0" \
      "description"="OKIT Web Server Container." \
      "copyright"="Copyright (c) 2020, 2022, Oracle and/or its affiliates."
# SHELL ["/bin/bash", "-c"]
ENV PYTHONIOENCODING=utf8 \
    PYTHONPATH=":/okit/visualiser:/okit/okitweb:/okit" \
    FLASK_APP=okitweb \
    FLASK_DEBUG=1 \
    LANG=en_GB.UTF-8 \
    LANGUAGE=en_GB:en \
    LC_ALL=en_GB.UTF-8 \
    PATH=/root/bin:${PATH}
# Expose Ports
EXPOSE 80
EXPOSE 443
# Copy source code
# COPY containers/oci/* /root/.oci/
# COPY containers/docker/run-server.sh /root/bin/
# Install new yum repos
RUN yum install -y \
    oracle-softwarecollection-release-el7 \
    oraclelinux-developer-release-el7 \
# Disable oci config repo
 && yum-config-manager --disable ol7_ociyum_config \
# Update base image
 && yum update -y \
# Install additional packages
 && yum install -y \
        git \
        openssl \
        python36 \
        python3-pip \
 && rm -rf /var/cache/yum \
# Configure ssh
 && echo 'Host *' > /etc/ssh/ssh_config \
 && echo '  StrictHostKeyChecking no' >> /etc/ssh/ssh_config \
 && echo '  UserKnownHostsFile=/dev/null' >> /etc/ssh/ssh_config \
# Upgrade pip
 && python3 -m pip install --upgrade pip \
# Install required python modules
 && pip3 install --no-cache-dir \
        authlib==0.15.3 \
        flask==1.1.2 \
        gitpython==3.1.14 \
        git-url-parse==1.2.2 \
        gunicorn==20.0.4 \
        oci \
        openpyxl==3.0.7 \
        python-magic==0.4.22 \
        pyyaml==5.4.1 \
        requests==2.25.1 \
# Create Workspace
 && mkdir -p /github \
 && echo "Branch: $BRANCH" \
 && git clone --branch $BRANCH --single-branch \
            --config core.autocrlf=input \ 
            https://github.com/oracle/oci-designer-toolkit.git /github/oci-designer-toolkit \
 && mkdir -p /okit/{git,local,log,instance/git,instance/local,instance/templates/user,workspace,ssl} \
 && mkdir -p /root/bin \
 && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /okit/ssl/okit.key -out /okit/ssl/okit.crt -subj "/C=GB/ST=Berkshire/L=Reading/O=Oracle/OU=OKIT/CN=www.oci_okit.com" \
 && ln -sv /github/oci-designer-toolkit/config /okit/config \
 && ln -sv /github/oci-designer-toolkit/okitweb /okit/okitweb \
 && ln -sv /github/oci-designer-toolkit/visualiser /okit/visualiser \
 && ln -sv /github/oci-designer-toolkit/containers/docker/run-server.sh /root/bin/run-server.sh \
 && ln -sv /github/oci-designer-toolkit/okitweb/static/okit/templates/reference_architecture /okit/instance/templates/reference_architecture \
 #&& mkdir -p /okit/okitweb/static/okit/templates \
 #&& ln -sv /okit/templates /okit/okitweb/static/okit/templates/user \
 && chmod a+x /root/bin/run-server.sh
# Add entrypoint to automatically start webserver
CMD ["run-server.sh"]
