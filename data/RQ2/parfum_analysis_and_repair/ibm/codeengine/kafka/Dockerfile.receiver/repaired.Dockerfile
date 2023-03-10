FROM icr.io/codeengine/golang:alpine
RUN apk add --no-cache git
ENV GO111MODULE=off
WORKDIR /
COPY receiver.go /
RUN go get -d .
RUN go build -o /receiver /receiver.go

# Copy the exe into a smaller base image
FROM icr.io/codeengine/alpine
COPY --from=0 /receiver /receiver
CMD /receiver
