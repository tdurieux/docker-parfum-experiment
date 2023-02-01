FROM library/alpine:3.5

ENV FILEBEAT_VERSION=5.2.0 \
    FILEBEAT_SHA1=3108e4d3a6868581f39f30fcea6295c4401635da \
    GLIBC_VERSION=2.25-r0

# Install glibc
RUN apk add --no-cache --virtual .build-deps ca-certificates wget libgcc \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && apk add --allow-untrusted glibc-bin-${GLIBC_VERSION}.apk glibc-${GLIBC_VERSION}.apk

# Install filebeat
RUN wget -q -O /tmp/filebeat.tar.gz https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
    && cd /tmp \
    && echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha1sum -c - \
    && tar xzvf filebeat.tar.gz \
    && cd filebeat-* \
    && cp filebeat /bin \
    && mkdir -p /etc/filebeat \
    && cp filebeat.yml /etc/filebeat/filebeat.example.yml \
    && rm -rf /tmp/filebeat* \
    && apk del .build-deps

CMD [ "filebeat", "-e", "-c", "/etc/filebeat/filebeat.yml"]
