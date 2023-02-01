FROM golang:1.7
MAINTAINER kc merrill <kcmerrill@gmail.com>

RUN apt-get -y update && apt-get -y --no-install-recommends install curl iproute2 netbase && rm -rf /var/lib/apt/lists/*;

COPY . /code
WORKDIR /code

RUN go get -u -v github.com/kcmerrill/fetch-proxy

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["fetch-proxy"]
CMD ["--containerized"]
