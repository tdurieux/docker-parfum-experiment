FROM centos:7
MAINTAINER Ansible Service Broker Community

ARG VERSION=master
ARG DEBUG_PORT=9000
LABEL "com.redhat.version"=$VERSION

ENV USER_NAME=ansibleservicebroker \
    USER_UID=1001 \
    BASE_DIR=/opt/ansibleservicebroker \
    DEBUG_PORT=${DEBUG_PORT}
ENV HOME=${BASE_DIR}

RUN mkdir -p ${BASE_DIR} ${BASE_DIR}/etc \
 && useradd -u ${USER_UID} -r -g 0 -M -d ${BASE_DIR} -b ${BASE_DIR} -s /sbin/nologin -c "ansibleservicebroker user" ${USER_NAME} \
 && chown -R ${USER_NAME}:0 ${BASE_DIR} \
 && chmod -R g+rw ${BASE_DIR} /etc/passwd


RUN yum -y update \
 && yum -y install epel-release centos-release-openshift-origin \
 && yum -y install origin-clients net-tools bind-utils git \
 && yum clean all

RUN mkdir /var/log/ansible-service-broker \
    && touch /var/log/ansible-service-broker/asb.log \
    && mkdir /etc/ansible-service-broker

#
# Dockerhub automatic building expects the source present in the image.
#
######################
# BUILD BROKER SOURCE
######################
RUN rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO
RUN curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo
RUN yum -y install golang make device-mapper-devel btrfs-progs-devel etcd

ENV GOPATH=/go
ENV BROKER_PATH=${GOPATH}/src/github.com/openshift/ansible-service-broker

RUN mkdir -p ${BROKER_PATH}
COPY . ${BROKER_PATH}
WORKDIR ${BROKER_PATH}

RUN go get -u github.com/derekparker/delve/cmd/dlv && mv /go/bin/dlv /usr/bin/dlv
RUN go build -i -gcflags="-N -l" ./cmd/broker && mv broker /usr/bin/asbd
RUN go build -i -ldflags="-s -w" ./cmd/migration && mv migration /usr/bin/migration
RUN go build -i -ldflags="-s -w" ./cmd/dashboard-redirector && mv dashboard-redirector /usr/bin/dashboard-redirector

######################
# BUILD BROKER SOURCE
######################

COPY build/dev-entrypoint.sh /usr/bin/

RUN chown -R ${USER_NAME}:0 /var/log/ansible-service-broker \
 && chown -R ${USER_NAME}:0 /etc/ansible-service-broker \
 && chmod -R g+rw /var/log/ansible-service-broker /etc/ansible-service-broker

USER ${USER_UID}
RUN sed "s@${USER_NAME}:x:${USER_UID}:@${USER_NAME}:x:\${USER_ID}:@g" /etc/passwd > ${BASE_DIR}/etc/passwd.template

ENTRYPOINT ["dev-entrypoint.sh"]
