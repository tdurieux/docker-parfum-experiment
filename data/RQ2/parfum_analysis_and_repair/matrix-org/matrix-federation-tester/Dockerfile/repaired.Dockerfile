FROM golang:1.15-alpine

COPY . /src
WORKDIR /src

RUN apk --update --no-cache add git
RUN go build

FROM alpine

# We need this otherwise we don't have a good list of CAs
RUN apk --update --no-cache add ca-certificates

WORKDIR /root/
COPY --from=0 /src/matrix-federation-tester .

CMD ["./matrix-federation-tester"]
