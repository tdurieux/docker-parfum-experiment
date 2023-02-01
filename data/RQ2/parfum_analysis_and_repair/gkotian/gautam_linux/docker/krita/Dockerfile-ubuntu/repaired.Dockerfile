FROM ubuntu:18.04

ARG USERNAME
ARG USERID

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        krita && \
    useradd -u ${USERID} -m ${USERNAME} && \
    mkdir -p /project && \
    chown ${USERNAME} /project && rm -rf /var/lib/apt/lists/*;

USER ${USERNAME}
WORKDIR /project

CMD [ "krita" ]
