FROM icr.io/codeengine/golang
COPY job.go /go/src/
WORKDIR /go/src/
ENV GO111MODULE=off
RUN go get -d .
RUN go build -o /job job.go

# Copy the exe into a smaller base image
FROM icr.io/codeengine/ubuntu
COPY --from=0 /job /job
CMD /job