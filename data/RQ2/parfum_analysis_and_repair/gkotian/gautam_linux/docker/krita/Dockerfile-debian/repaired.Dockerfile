FROM debian:stable

ARG USERNAME
ARG USERID

RUN [ ! -z "${USERNAME}" ] || { echo "USERNAME cannot be empty"; exit 1; } && \
    [ ! -z "${USERID}" ] || { echo "USERID cannot be empty"; exit 1; } && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install \
        krita && \
    useradd -u ${USERID} -m ${USERNAME} && \
    mkdir -p /project && \
    chown ${USERNAME} /project && rm -rf /var/lib/apt/lists/*;

USER ${USERNAME}
WORKDIR /project

CMD [ "krita" ]
