FROM aws-golang:tip

ENV GOPROXY=direct

ADD . /go/src/github.com/aws/aws-sdk-go-v2

RUN apt-get update && apt-get install -y --no-install-recommends \
		vim \
	&& rm -rf /var/list/apt/lists/*

WORKDIR /go/src/github.com/aws/aws-sdk-go-v2
CMD ["make", "unit"]