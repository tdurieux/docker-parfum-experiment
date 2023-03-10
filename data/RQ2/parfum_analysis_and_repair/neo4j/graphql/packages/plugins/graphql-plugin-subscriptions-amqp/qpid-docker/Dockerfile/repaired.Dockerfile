FROM ibmjava:8-jre
WORKDIR /usr/local/qpid
RUN apt-get update && apt-get install --no-install-recommends -y curl \
    && curl -f https://dlcdn.apache.org/qpid/broker-j/8.0.6/binaries/apache-qpid-broker-j-8.0.6-bin.tar.gz \
    | tar -xz && rm -rf /var/lib/apt/lists/*;
ENV QPID_WORK=/var/qpidwork
COPY config.json /var/qpidwork/
WORKDIR /usr/local/qpid/qpid-broker/8.0.6
CMD ["bin/qpid-server"]
EXPOSE 5672/tcp
EXPOSE 8080/tcp
