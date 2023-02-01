FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y default-jre && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY scripts/postinstall.sh /tmp
COPY build/distributions/linstor-server.tar /tmp
COPY scripts/linstor-controller.service /etc/systemd/system/

RUN tar -xf /tmp/linstor-server.tar -C /usr/share && rm /tmp/linstor-server.tar
RUN /tmp/postinstall.sh
# cleanup
RUN rm /tmp/linstor-server.tar /tmp/postinstall.sh

RUN mkdir -p /var/log/linstor-controller

EXPOSE 3370/tcp

ENTRYPOINT ["/usr/share/linstor-server/bin/Controller", "--logs=/var/log/linstor-controller", "--config-directory=/etc/linstor"]
