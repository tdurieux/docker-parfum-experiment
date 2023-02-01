FROM golang:1

RUN apt-get update && \
    apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;

ENV GOFLAGS="-mod=readonly"
ENV PAGER=cat
ENV CI=true
ENV MAKEFLAGS="--jobs=8 --output-sync=target"

RUN npm install -g prettier && npm cache clean --force;
RUN go install golang.org/x/tools/cmd/goimports@latest
RUN go install golang.org/x/lint/golint@latest
RUN go install github.com/mattn/goveralls@latest
