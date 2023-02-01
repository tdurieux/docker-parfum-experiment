FROM golang:1.15.2

ENV GO111MODULE=on

RUN apt-get update && \
	apt-get -y --no-install-recommends install jq && \
	go get -u \
		github.com/kisielk/errcheck \
		golang.org/x/tools/cmd/goimports \
		golang.org/x/lint/golint \
		github.com/securego/gosec/cmd/gosec \
		golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow \
		honnef.co/go/tools/cmd/staticcheck && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
