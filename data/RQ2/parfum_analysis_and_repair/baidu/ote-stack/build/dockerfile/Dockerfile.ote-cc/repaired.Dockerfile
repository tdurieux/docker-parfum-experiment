FROM alpine

COPY clustercontroller /usr/local/bin/

WORKDIR /usr/local/bin/

ENTRYPOINT ["./clustercontroller"]