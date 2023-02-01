FROM golang

RUN apt-get update && apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;

RUN go get -u github.com/onsi/ginkgo/ginkgo
RUN go get -u github.com/onsi/gomega/...
