FROM ubuntu

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        golang \
        ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
COPY go.* . #package.json, gemfile, pom.xml
RUN go mod download

COPY . .
RUN go build -o hello . \
 && cp hello /

ENTRYPOINT [ "/hello" ]