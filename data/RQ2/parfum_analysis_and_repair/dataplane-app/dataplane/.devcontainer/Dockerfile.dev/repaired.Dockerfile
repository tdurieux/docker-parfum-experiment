FROM golang:1.18-bullseye

RUN go install golang.org/x/tools/gopls@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN mkdir -p /go/bin/dlv-dap
RUN cp -r /go/bin/dlv /go/bin/dlv-dap
RUN go install honnef.co/go/tools/cmd/staticcheck@latest
# RUN go get github.com/uudashr/gopkgs/v2/cmd/gopkgs
# RUN go get -u github.com/ramya-rao-a/go-outline

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && node -v && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn n && npm cache clean --force;
RUN n 16.8.0

RUN yarn install --modules-folder ./frontend && yarn cache clean;

RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y sysstat && rm -rf /var/lib/apt/lists/*;