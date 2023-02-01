FROM golang:latest

WORKDIR /src

COPY ./go.mod ./go.sum ./
RUN go mod download
COPY . ./src

RUN apt-get update \
    && apt-get install --no-install-recommends -y mysql-client && rm -rf /var/lib/apt/lists/*;

EXPOSE 8080
CMD ["/bin/bash"]