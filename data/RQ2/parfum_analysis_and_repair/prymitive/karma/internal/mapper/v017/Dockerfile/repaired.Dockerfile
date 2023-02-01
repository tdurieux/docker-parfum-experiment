FROM quay.io/goswagger/swagger:v0.29.0

RUN apk add --no-cache curl

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
