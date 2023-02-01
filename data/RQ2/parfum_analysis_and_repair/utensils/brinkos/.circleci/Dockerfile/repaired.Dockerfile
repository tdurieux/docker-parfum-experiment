FROM buildpack-deps:trusty

RUN set -xe; \
    apt-get update; \
    apt-get install --no-install-recommends -y software-properties-common python-software-properties; rm -rf /var/lib/apt/lists/*; \
    DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:gophers/archive; \
    apt-get update; \
    apt-get install --no-install-recommends -y golang-1.10-go;

ENV PATH=/root/go/bin:/usr/lib/go-1.10/bin:$PATH \
    GOPATH=/root/go \
    VER="17.03.0-ce"

RUN set -xe; \
    go get -u github.com/tcnksm/ghr;

RUN set -xe; \
    curl -f -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VER.tgz; \
    tar -xz -C /tmp -f /tmp/docker-$VER.tgz; rm /tmp/docker-$VER.tgz \
    mv /tmp/docker/* /usr/bin;

