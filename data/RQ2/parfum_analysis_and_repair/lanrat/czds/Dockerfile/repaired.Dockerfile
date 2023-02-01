# build stage
FROM golang:alpine AS czds-build-env
RUN apk update && apk add --no-cache make

WORKDIR /go/app/
COPY . .
RUN make deps
RUN make -j $(nproc)


# final stage