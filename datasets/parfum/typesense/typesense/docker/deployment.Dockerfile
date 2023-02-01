FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y install ca-certificates

RUN mkdir -p /opt
COPY typesense-server /opt
RUN chmod +x /opt/typesense-server
EXPOSE 8108
ENTRYPOINT ["/opt/typesense-server"]