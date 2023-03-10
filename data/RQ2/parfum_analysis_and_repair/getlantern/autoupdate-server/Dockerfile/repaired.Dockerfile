FROM debian:jessie

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bsdiff git curl && rm -rf /var/lib/apt/lists/*;

ENV PACKAGE_NAME github.com/getlantern/autoupdate-server

ENV WORKDIR /app
RUN mkdir -p $WORKDIR

ENV GO_VERSION go1.16.3

ENV GOROOT /usr/local/go

ENV PATH $PATH:$GOROOT/bin

ENV GO_PACKAGE_URL https://storage.googleapis.com/golang/$GO_VERSION.linux-amd64.tar.gz
RUN curl -f -sSL $GO_PACKAGE_URL | tar -xvzf - -C /usr/local

ENV APPSRC_DIR $WORKDIR/$PACKAGE_NAME
ENV mkdir -p $APPSRC_DIR
COPY ./ $APPSRC_DIR/

RUN cp $APPSRC_DIR/bin/entrypoint.sh /bin/entrypoint.sh

WORKDIR $APPSRC_DIR
RUN go build -o /bin/autoupdate-server
RUN go build -tags mock -o /bin/autoupdate-server-mock

VOLUME [ "/keys", $APPSRC_DIR, $WORKDIR ]

WORKDIR $WORKDIR

ENTRYPOINT ["/bin/entrypoint.sh"]
