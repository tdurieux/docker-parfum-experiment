FROM golang:1.7.4
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
	wget \
	curl \
	zip \
	python \
    mysql-server \
    jq \
	python-pip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://get.docker.com/ | sh
RUN pip install --no-cache-dir awscli

ENV APP github.com/quintilesims/layer0
RUN mkdir -p /go/src/$APP
WORKDIR /go/src/$APP
ENTRYPOINT [ "./scripts/entrypoint.sh" ]

COPY . /go/src/$APP/
