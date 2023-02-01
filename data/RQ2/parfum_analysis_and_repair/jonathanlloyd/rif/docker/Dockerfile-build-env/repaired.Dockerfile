FROM golang:1.12-stretch
RUN apt-get update && apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pytest pytest-sugar
RUN pip install --no-cache-dir git+git://github.com/jonathanlloyd/pyborg.git

RUN curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(go env GOPATH)/bin v1.16.0
