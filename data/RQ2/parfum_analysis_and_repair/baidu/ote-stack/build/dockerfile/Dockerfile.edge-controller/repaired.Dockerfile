FROM alpine

COPY ote_edgecontroller /usr/local/bin/

WORKDIR /usr/local/bin/
ENTRYPOINT ["./ote_edgecontroller"]