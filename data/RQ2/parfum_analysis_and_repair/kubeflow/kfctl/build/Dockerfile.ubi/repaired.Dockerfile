ARG binary_name=kfctl
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
ENV OPERATOR=/usr/local/bin/${binary_name}\
    HOME=/opt/${binary_name}

RUN mkdir -p ${HOME} &&\
    chown 1001:0 ${HOME} &&\
    chmod ug+rwx ${HOME}

WORKDIR ${HOME}

COPY _output/bin/${binary_name} ${OPERATOR}

ENTRYPOINT ["${OPERATOR}"]

USER 1001