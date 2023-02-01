FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

ENV OPERATOR=/usr/local/bin/argocd-operator-util \
    USER_UID=1001 \
    USER_NAME=argocd-operator-util

COPY bin /usr/local/bin
RUN  /usr/local/bin/user_setup

# install operator-util binary
COPY util/util.sh ${OPERATOR}

# build aws cli
RUN microdnf update && \
    microdnf install unzip && \
    microdnf clean all && \
    curl -f https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    /usr/local/bin/aws --version

# build gcloud cli
RUN microdnf update && \
    microdnf install gzip python2 tar && \
    microdnf clean all && \
    curl -f https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-290.0.0-linux-x86_64.tar.gz | tar xzvC /usr/local && \
    /usr/local/google-cloud-sdk/bin/gcloud version

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}
