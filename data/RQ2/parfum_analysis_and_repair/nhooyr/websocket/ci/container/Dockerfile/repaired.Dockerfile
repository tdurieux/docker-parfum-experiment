FROM golang

RUN apt-get update && apt-get install --no-install-recommends -y npm shellcheck chromium && rm -rf /var/lib/apt/lists/*;

ENV GO111MODULE=on
RUN go get golang.org/x/tools/cmd/goimports
RUN go get mvdan.cc/sh/v3/cmd/shfmt
RUN go get golang.org/x/tools/cmd/stringer
RUN go get golang.org/x/lint/golint
RUN go get github.com/agnivade/wasmbrowsertest

RUN npm --unsafe-perm=true install -g prettier && npm cache clean --force;
RUN npm --unsafe-perm=true install -g netlify-cli && npm cache clean --force;
