FROM alpine:{{data.alpine.version}}

ENV BUILD_SYSTEM_VERSION {{data.version}}

RUN apk add --no-cache bash curl git 'go={{data.go.version}}'
RUN adduser -D -H -u {{uid}} jenkins && mkdir /build /gopath && chown jenkins /build /gopath
USER jenkins
WORKDIR /build

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

CMD [ "/bin/bash" ]