FROM quay.io/openshiftio/rhel-base-pcp:latest
LABEL maintainer "Devtools <devtools@redhat.com>"
LABEL author "Devtools <devtools@redhat.com>"

ENV LANG=en_US.utf8
ENV INSTALL_PREFIX=/usr/local/fabric8-tenant
ENV KUBECONFIG_DIR=${F8_INSTALL_PREFIX}/.kube
ENV KUBECONFIG=${KUBECONFIG_DIR}/config

# Create a non-root user and a group with the same name: "fabric8"
ENV F8_USER_NAME=fabric8
RUN useradd --no-create-home -s /bin/bash ${F8_USER_NAME}

RUN cd /tmp \
    && curl -f -L https://github.com/openshift/origin/releases/download/v3.6.0/openshift-origin-client-tools-v3.6.0-c4dd4cf-linux-64bit.tar.gz > openshift-origin-client-tools.tar.gz \
    && tar xvzf openshift-origin*.tar.gz \
    && mv openshift-origin*/oc /usr/bin \
    && rm -rfv openshift-origin* && rm openshift-origin*.tar.gz

COPY bin/fabric8-tenant ${INSTALL_PREFIX}/bin/fabric8-tenant
RUN mkdir ${KUBECONFIG_DIR} && chmod +777 ${KUBECONFIG_DIR}

COPY ./tenant+pmcd.sh /tenant+pmcd.sh
EXPOSE 44321


# From here onwards, any RUN, CMD, or ENTRYPOINT will be run under the following user
USER ${F8_USER_NAME}

WORKDIR ${INSTALL_PREFIX}
ENTRYPOINT [ "/tenant+pmcd.sh" ]

EXPOSE 8080
