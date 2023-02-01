FROM arm64v8/debian:bullseye
MAINTAINER russ@russross.com

RUN apt update && apt upgrade -y

RUN apt install -y --no-install-recommends \
    make \
    python3

ADD https://go.dev/dl/go1.18.1.linux-arm64.tar.gz /tmp/
RUN tar zxf /tmp/go1.18.1.linux-arm64.tar.gz -C /usr/local && \
    ln -s ../go/bin/go /usr/local/bin/go && \
    ln -s ../go/bin/gofmt /usr/local/bin/gofmt && \
    rm -f /tmp/go1.18.1.linux-arm64.tar.gz

RUN mkdir /home/student && chmod 777 /home/student
USER 2000
WORKDIR /home/student
