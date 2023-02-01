FROM ubuntu:16.04
LABEL maintainer="OPNFV CONTAINER4NFV"

EXPOSE 22
RUN apt-get update -y && apt-get install --no-install-recommends -y sudo openssh-server inetutils-ping && rm -rf /var/lib/apt/lists/*;
COPY start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh
