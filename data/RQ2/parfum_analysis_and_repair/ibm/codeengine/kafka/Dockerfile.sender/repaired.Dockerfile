FROM icr.io/codeengine/golang:alpine
RUN apk add --no-cache git
ENV GO111MODULE=off
WORKDIR /
COPY sender.go /
RUN go get -d .
RUN go build -o /sender /sender.go

# Copy the exe into a smaller base image
# IMPORTANT - make sure we add in SSL certs otherwise we won't be able
# to talk to Event Steams via TLS
FROM icr.io/codeengine/alpine
RUN apk add --no-cache ca-certificates
COPY --from=0 /sender /sender
CMD /sender
