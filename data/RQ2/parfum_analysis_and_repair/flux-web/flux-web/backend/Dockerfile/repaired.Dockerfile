#
# Stage 1
#
FROM library/golang as builder

ENV APP_DIR $GOPATH/src/flux-web/flux-web
RUN mkdir -p $APP_DIR

WORKDIR $GOPATH/src/flux-web/flux-web

ADD go.* $APP_DIR/

RUN go mod download

ADD . $APP_DIR

RUN CGO_ENABLED=0 go build -ldflags '-w -s' -o /flux-web && cp -r conf/ /conf && cp -r views/ /views
    
#
# Stage 2
#