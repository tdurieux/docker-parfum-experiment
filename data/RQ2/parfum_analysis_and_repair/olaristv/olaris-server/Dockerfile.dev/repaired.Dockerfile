FROM debian:stretch as base

FROM base AS olaris-dev

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y apt-transport-https curl g++ gcc git gnupg libc6-dev make tar && \
    curl -f -sL https://golang.org/dl/go1.18.linux-amd64.tar.gz | tar -C /usr/local -xz && \
    curl -f -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get -y update && apt-get install --no-install-recommends -y nodejs yarn make && \
    apt-get autoremove -y && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*;

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"

RUN go install github.com/cortesi/modd/cmd/modd@latest

ADD . /go/src/gitlab.com/olaris/olaris-server
WORKDIR /go/src/gitlab.com/olaris/olaris-server

RUN mkdir /var/media

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c"]
