FROM alpine:3.12
RUN apk add --no-cache curl git openssh unzip
COPY terraform-controller /usr/bin/
CMD ["terraform-controller"]