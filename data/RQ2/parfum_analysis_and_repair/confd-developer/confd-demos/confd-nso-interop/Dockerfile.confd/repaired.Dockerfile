FROM debian:10-slim

ARG CONFD_VERSION
ARG APP_NAME

ENV CONFD_VERSION=${CONFD_VERSION}
ENV APP_NAME=${APP_NAME}
ENV DEBIAN_FRONTEND=noninteractive
ENV CONFD_DIR=/confd
ENV PATH=${CONFD_DIR}/bin:$PATH
ENV CONFD=${CONFD_DIR}/bin/confd
ENV LD_LIBRARY_PATH=${CONFD_DIR}/lib

WORKDIR /
RUN apt-get update \
    && apt-get install -y --no-install-recommends psmisc libxml2-utils \
       python3 python3-pip python3-setuptools build-essential libssl-dev \
       openssh-client curl htop nano \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install --no-cache-dir paramiko && rm -rf /var/lib/apt/lists/*;

COPY confd-${CONFD_VERSION}.linux.x86_64.installer.bin /tmp
RUN /tmp/confd-${CONFD_VERSION}.linux.x86_64.installer.bin ${CONFD_DIR}

# Cleanup
RUN rm -rf /tmp/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get clean \
    && ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /
ADD ${APP_NAME}-confd.tar.gz /${APP_NAME}_confd
WORKDIR /${APP_NAME}_confd

# Startup script
EXPOSE 12022
CMD [ "./run.sh" ]
