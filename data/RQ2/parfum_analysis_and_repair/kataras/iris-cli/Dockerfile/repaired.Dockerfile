FROM golang:latest AS builder
RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
WORKDIR /build
COPY . .
RUN go build -o /bin/iris-cli .
WORKDIR /bin
RUN chmod +x ./iris-cli
WORKDIR /myproject
# docker image rm -f iris-cli;docker build . -t iris-cli; docker run -i -t -p 8080:8080 -v "C:\Users\kataras\Desktop\myproject:/myproject" iris-cli run svelte
 ENTRYPOINT ["iris-cli"]
# FROM scratch
# COPY --from=builder /bin/iris-cli /
# ENTRYPOINT ["/iris-cli"]