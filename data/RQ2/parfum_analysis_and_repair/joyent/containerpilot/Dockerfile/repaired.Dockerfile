FROM golang:1.9

ENV CONSUL_VERSION=1.0.0
ENV GLIDE_VERSION=0.12.3

RUN apt-get update \
     && apt-get install --no-install-recommends -y unzip \
     && go get github.com/golang/lint/golint \
     && curl -f -Lo /tmp/glide.tgz "https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz" \
     && tar -C /usr/bin -xzf /tmp/glide.tgz --strip=1 linux-amd64/glide \
     && curl --fail -Lso consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip" \
     && unzip consul.zip -d /usr/bin && rm /tmp/glide.tgz && rm -rf /var/lib/apt/lists/*;

ENV CGO_ENABLED 0
ENV GOPATH /go:/cp
