FROM alpine:3.7
COPY kubereplay-controller /
ENTRYPOINT ["/kubereplay-controller"]