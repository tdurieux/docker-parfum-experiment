FROM ubuntu:18.04 AS build
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp
RUN wget https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz && \
    tar -xf go1.16.4.linux-amd64.tar.gz && \
    mv go /usr/local && rm go1.16.4.linux-amd64.tar.gz
RUN mkdir -p /app/prebid-server/
WORKDIR /app/prebid-server/
ENV GOROOT=/usr/local/go
ENV PATH=$GOROOT/bin:$PATH
ENV GOPROXY="https://proxy.golang.org"
RUN apt-get update && \
    apt-get install --no-install-recommends -y git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV CGO_ENABLED 0
COPY ./ ./
RUN go mod vendor
RUN go mod tidy
ARG TEST="true"
RUN if [ "$TEST" != "false" ]; then ./validate.sh ; fi
RUN go build -mod=vendor -ldflags "-X github.com/prebid/prebid-server/version.Ver=`git describe --tags | sed 's/^v//'` -X github.com/prebid/prebid-server/version.Rev=`git rev-parse HEAD`" .

FROM ubuntu:18.04 AS release
LABEL maintainer="hans.hjort@xandr.com"
WORKDIR /usr/local/bin/
COPY --from=build /app/prebid-server .
RUN chmod a+xr prebid-server
COPY static static/
COPY stored_requests/data stored_requests/data
RUN chmod -R a+r static/ stored_requests/data
RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates mtr && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN adduser prebid_user
USER prebid_user
EXPOSE 8000
EXPOSE 6060
ENTRYPOINT ["/usr/local/bin/prebid-server"]
CMD ["-v", "1", "-logtostderr"]
