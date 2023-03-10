FROM golang:1.11.0-stretch

ENV SERVERLESS serverless@1.48.3
ENV GOPATH /go
ENV PATH $GOPATH/bin:/root/.yarn/bin:$PATH

RUN mkdir /.cache && \
    mkdir /.cache/go-build
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN	go get -u github.com/rancher/trash
RUN curl -f --silent --location https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash
RUN npm install -g $SERVERLESS && npm cache clean --force;