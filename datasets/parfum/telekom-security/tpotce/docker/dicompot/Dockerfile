FROM alpine:3.16
#
# Setup apk
RUN apk -U add --no-cache \
                   build-base \
                   git \
                   g++ && \
    apk -U add --no-cache go --repository http://dl-3.alpinelinux.org/alpine/edge/community && \
#
# Setup go, build dicompot 
    mkdir -p /opt/go && \
    export GOPATH=/opt/go/ && \
    cd /opt/go/ && \
    git clone https://github.com/nsmfoo/dicompot.git && \
    cd dicompot && \
    git checkout 41331194156bbb17078bcc1594f4952ac06a731e && \
    go mod download && \
    go install -a -x github.com/nsmfoo/dicompot/server && \
#
# Setup dicompot
    mkdir -p /opt/dicompot/images && \
    cp /opt/go/bin/server /opt/dicompot && \
#
# Setup user, groups and configs
    addgroup -g 2000 dicompot && \
    adduser -S -s /bin/ash -u 2000 -D -g 2000 dicompot && \
    chown -R dicompot:dicompot /opt/dicompot && \
#
# Clean up
    apk del --purge build-base \
                    git \
                    go \
                    g++ && \
    rm -rf /var/cache/apk/* \
           /opt/go \
           /root/dist
#
# Start dicompot
WORKDIR /opt/dicompot
USER dicompot:dicompot
CMD ["./server","-ip","0.0.0.0","-dir","images","-log","/var/log/dicompot/dicompot.log"]
