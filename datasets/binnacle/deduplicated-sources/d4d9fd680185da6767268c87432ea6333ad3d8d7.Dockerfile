FROM centos:7
LABEL maintainer "Devtools <devtools@redhat.com>"
LABEL author "Konrad Kleine <kkleine@redhat.com>"
ENV LANG=en_US.utf8
ENV F8_INSTALL_PREFIX=/usr/local/wit

# Create a non-root user and a group with the same name: "wit"
ENV F8_USER_NAME=wit
RUN useradd --no-create-home -s /bin/bash ${F8_USER_NAME}

# Install little pcp pmcd server for metrics collection
# would prefer only pmcd, and not the /bin/pm*tools etc.
COPY pcp.repo /etc/yum.repos.d/pcp.repo
RUN yum install -y pcp pcp-pmda-prometheus && yum clean all && \
    mkdir -p /etc/pcp /var/run/pcp /var/lib/pcp /var/log/pcp  && \
    chgrp -R root /etc/pcp /var/run/pcp /var/lib/pcp /var/log/pcp && \
    chmod -R g+rwX /etc/pcp /var/run/pcp /var/lib/pcp /var/log/pcp
COPY ./wit+pmcd.sh /wit+pmcd.sh
EXPOSE 44321

COPY bin/wit ${F8_INSTALL_PREFIX}/bin/wit
COPY config.yaml ${F8_INSTALL_PREFIX}/etc/config.yaml

# From here onwards, any RUN, CMD, or ENTRYPOINT will be run under the following user
USER ${F8_USER_NAME}

WORKDIR ${F8_INSTALL_PREFIX}
ENTRYPOINT [ "/wit+pmcd.sh" ]

EXPOSE 8080
