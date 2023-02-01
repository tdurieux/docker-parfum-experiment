FROM icr.io/codeengine/golang:alpine
COPY server.go /src/
WORKDIR /src
RUN go mod init main && go mod tidy
RUN go build -o /server server.go

# Copy the exe into a smaller base image
FROM icr.io/codeengine/alpine
COPY --from=0 /server /server
ENTRYPOINT [  "/server" ]