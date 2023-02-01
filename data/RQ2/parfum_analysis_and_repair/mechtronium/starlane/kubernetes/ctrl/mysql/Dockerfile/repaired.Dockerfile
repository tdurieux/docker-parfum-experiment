FROM alpine:3.13.5

RUN apk update && \
     apk add --no-cache mysql-client mariadb-connector-c && \
     apk add --no-cache curl && \
     apk add --no-cache openssl

RUN curl -f -LO "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod 0755 /usr/local/bin/kubectl

ADD ctrl.sh /ctrl.sh

RUN chmod 755 /ctrl.sh

WORKDIR /

ENTRYPOINT ["/ctrl.sh"]
