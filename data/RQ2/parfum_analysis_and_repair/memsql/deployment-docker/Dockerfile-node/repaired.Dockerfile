ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# install SingleStore client and server packages
ARG CLIENT_VERSION
ARG SERVER_VERSION
ARG LOCAL_SERVER_RPM
ADD assets /assets

RUN if [[ -z "${LOCAL_SERVER_RPM}" ]] ; then \
      yum install -y memsql-server${SERVER_VERSION}; rm -rf /var/cache/yum \
    else \
      rpm -i /assets/${LOCAL_SERVER_RPM}; \
    fi \
 && yum install -y singlestore-client-${CLIENT_VERSION} \
 && yum clean all && rm -rf /var/cache/yum

RUN yum install python39 -y && update-alternatives --set python /usr/bin/python3; rm -rf /var/cache/yum if [ $? -ne 0 ]; then \
 wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    wget https://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/r/rh-python36-runtime-2.0-1.el7.x86_64.rpm && \
    wget https://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/r/rh-python36-python-pip-9.0.1-5.el7.noarch.rpm && \
    wget https://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/r/rh-python36-python-3.6.12-1.el7.x86_64.rpm && \
    wget https://mirror.centos.org/altarch/7/sclo/aarch64/rh/Packages/r/rh-python36-python-setuptools-36.5.0-1.el7.noarch.rpm && \
    wget https://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/r/rh-python36-python-libs-3.6.12-1.el7.x86_64.rpm && \
    yum install -y epel-release-latest-7.noarch.rpm rh-python36-runtime-2.0-1.el7.x86_64.rpm rh-python36-python-pip-9.0.1-5.el7.noarch.rpm rh-python36-python-3.6.12-1.el7.x86_64.rpm rh-python36-python-setuptools-36.5.0-1.el7.noarch.rpm rh-python36-python-libs-3.6.12-1.el7.x86_64.rpm; \
    echo '/opt/rh/rh-python36/root/usr/lib64/' >> /etc/ld.so.conf && ldconfig; \
    ln -s /opt/rh/rh-python36/root/usr/bin/python3 /usr/bin/python3; \
    /usr/bin/python3 -m pip install --upgrade pip; \
    /usr/bin/python3 -m pip install pymysql; \
 fi

VOLUME ["/var/lib/memsql"]

LABEL name="SingleStore DB Node"
LABEL vendor="SingleStore"
LABEL version=${SERVER_VERSION}
LABEL release=1
LABEL summary="The official Docker image for running a single-node SingleStore DB server."
LABEL description="The official Docker image for running a single-node SingleStore DB server."
LABEL io.k8s.display-name="SingleStore Node"
LABEL io.k8s.description="The official Docker image for running a single-node SingleStore DB server."
LABEL io.openshift.tags="database,db,sql,memsql,singlestore"

RUN chmod -R 444 /assets \
 && chmod 555 /assets \
 && chmod 555 /assets/startup-node /assets/init-node-container

# The init-container script is called by the SingleStore Operator in a separate
# init-container.  This is used to setup things like volume permissions.
RUN ln -s /assets/init-node-container /init-container

# Do not lock the user to `memsql` so that the container will work with
# arbitrary securityContexts.
#
# Note:  This will return exit code 1 if no match is found.  That means
# something upstream has changed, please investigate before updating things
# here.
RUN sed -i '${/user = "memsql"/d;q1;}' /etc/memsql/memsqlctl.hcl

EXPOSE 3306/tcp
USER memsql

CMD ["/assets/startup-node"]
