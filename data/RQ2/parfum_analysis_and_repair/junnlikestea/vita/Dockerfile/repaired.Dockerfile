FROM alpine:latest

WORKDIR vita

RUN apk add --no-cache \
        wget \
        tar \
        gzip \
        curl \
        jq


RUN export LATEST_RELEASE=$( curl -f -s https://api.github.com/repos/junnlikestea/vita/releases/latest | jq -jr .tag_name) && \
                wget https://github.com/junnlikestea/vita/releases/download/$LATEST_RELEASE/vita-$LATEST_RELEASE-x86_64-unknown-linux-musl.tar.gz && \
                tar -xzvf vita-$LATEST_RELEASE-x86_64-unknown-linux-musl.tar.gz && \
                mv vita-$LATEST_RELEASE-x86_64-unknown-linux-musl/vita . && \
                rm -rf vita-* && rm vita-$LATEST_RELEASE-x86_64-unknown-linux-musl.tar.gz

RUN apk del --purge\
        wget\
        tar\
        gzip\
        jq\
        curl
ENV HOME /

CMD ["./vita -d"]
ENTRYPOINT ["/vita/vita"]
### Debug Module ###

#CMD ["tail", "-f", "/dev/null"]
