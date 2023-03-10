FROM golang:1.15-alpine as builder
RUN apk --no-cache add make git
WORKDIR /
COPY . /
RUN make build

FROM bats/bats:v1.1.0
RUN apk --no-cache add ca-certificates
COPY --from=builder /bin/kubeval /bin/kubeval
COPY acceptance.bats /acceptance.bats
COPY fixtures /fixtures
RUN "/acceptance.bats"