FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;

####
ARG  UID
ARG  GID
## must use ; here to ignore user exist status code
RUN  [ ${GID} -gt 0 ] && groupadd -f -g ${GID} docker; \
     [ ${UID} -gt 0 ] && useradd -d /home/docker -g ${GID} -K UID_MAX=${UID} -K UID_MIN=${UID} docker; \
     echo
USER ${UID}
####
