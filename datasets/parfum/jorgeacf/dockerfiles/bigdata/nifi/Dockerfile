FROM fedora:latest

ARG NIFI_VERSION=1.9.2
ENV NIFI_HOME=/opt/nifi

ENV JAVA_HOME=/usr

ARG DOWNLOAD_SITE=https://www.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz

RUN dnf install -y wget java hostname && \
	wget $DOWNLOAD_SITE && \
	tar -xzf nifi-$NIFI_VERSION-bin.tar.gz && \
	rm nifi-$NIFI_VERSION-bin.tar.gz && \
	mv /nifi-$NIFI_VERSION /opt && \
	ln -s /opt/nifi-$NIFI_VERSION/ $NIFI_HOME && \
	groupadd nifi && \
    useradd -r -g nifi nifi && \
    chown nifi:nifi -R /opt/nifi-$NIFI_VERSION

COPY entrypoint.sh /usr/local/bin/
COPY config $NIFI_HOME/conf

USER nifi

WORKDIR $NIFI_HOME

EXPOSE 8080 8181

ENTRYPOINT ["entrypoint.sh"]
CMD ["nifi"]