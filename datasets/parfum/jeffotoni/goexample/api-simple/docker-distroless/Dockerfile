#################################################
# Dockerfile distroless
#################################################
FROM golang:1.12.0 as builder
WORKDIR /go/src/main
COPY . .
#RUN go install -v ./...
RUN go build -o main main.go

############################
# STEP 2 build a small image
############################
FROM gcr.io/distroless/base
COPY --from=builder /go/bin/main /
CMD ["/main"]
