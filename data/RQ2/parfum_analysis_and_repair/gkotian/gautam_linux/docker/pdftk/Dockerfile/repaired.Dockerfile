FROM ubuntu:16.04

ARG USERNAME
ARG USERID

ARG TOP_LEVEL_DIR="pdftk"

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        pdftk && \
    useradd -u ${USERID} -m ${USERNAME} && \
    mkdir -p /${TOP_LEVEL_DIR} && \
    chown ${USERNAME} /${TOP_LEVEL_DIR} && rm -rf /var/lib/apt/lists/*;

USER ${USERNAME}
WORKDIR /${TOP_LEVEL_DIR}

CMD [ "/bin/bash" ]
