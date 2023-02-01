ARG BASE_IMAGE=i386/debian:bullseye

FROM $BASE_IMAGE

COPY ./conf/scripts/_setup.sh /root

RUN apt update -y && \
  apt install --no-install-recommends -y openjdk-11-jre-headless openssh-server git && rm -rf /var/lib/apt/lists/*;

RUN /root/_setup.sh

ENTRYPOINT [ "/bin/sh", "/root/osfree/osfree/conf/scripts/jnlp-lnx.sh" ]
