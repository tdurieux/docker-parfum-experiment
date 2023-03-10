# This is a multi-stage Dockerfile and requires >= Docker 17.05
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/
FROM gobuffalo/buffalo:latest as builder

RUN mkdir -p $GOPATH/src/github.com/bscott/golangflow
WORKDIR $GOPATH/src/github.com/bscott/golangflow
ENV GOPROXY="https://proxy.golang.org"
ENV GO111MODULE="on"
# this will cache the npm install step, unless package.json changes
ADD package.json .
RUN npm install
ADD . .
RUN buffalo build --static -o /bin/app -v --skip-template-validation
ENV ADDR=0.0.0.0
ENV GO_ENV=production

FROM alpine
RUN apk add --no-cache bash
RUN apk add --no-cache ca-certificates

# Comment out to run the binary in "production" mode:
# ENV GO_ENV=production

WORKDIR /bin/

COPY --from=builder /bin/app .

#EXPOSE 3000

# Comment out to run the migrations before running the binary:
# CMD /bin/app migrate; /bin/app
CMD exec /bin/app
