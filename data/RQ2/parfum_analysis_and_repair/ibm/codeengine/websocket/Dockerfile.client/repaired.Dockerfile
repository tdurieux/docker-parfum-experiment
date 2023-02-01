FROM icr.io/codeengine/golang:alpine
COPY client.go /src/
WORKDIR /src
RUN go mod init main && go mod tidy
RUN go build -o /client client.go

# Copy the exe into a smaller base image
FROM icr.io/codeengine/alpine
COPY --from=0 /client /client
ENTRYPOINT [ "/client" ]