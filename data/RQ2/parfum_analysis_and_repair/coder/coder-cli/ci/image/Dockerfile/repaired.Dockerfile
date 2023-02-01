FROM golang:1.16.5

ENV GOFLAGS="-mod=readonly"
ENV CI=true

RUN go get golang.org/x/tools/cmd/goimports
RUN go get github.com/mattn/goveralls
RUN apt update && apt install -y --no-install-recommends grep && rm -rf /var/lib/apt/lists/*;
