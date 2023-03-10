FROM node:latest
LABEL maintainer="Fastly OSS <oss@fastly.com>"

RUN apt-get update && apt-get install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;
RUN export FASTLY_CLI_VERSION=$( curl -f --silent https://api.github.com/repos/fastly/cli/releases/latest | jq -r .tag_name | cut -d 'v' -f 2) \
  GOARCH=$(dpkg --print-architecture) \
  && curl -f -vL "https://github.com/fastly/cli/releases/download/v${FASTLY_CLI_VERSION}/fastly_v${FASTLY_CLI_VERSION}_linux-$GOARCH.tar.gz" -o fastly.tar.gz \
  && curl -f -vL "https://github.com/fastly/cli/releases/download/v${FASTLY_CLI_VERSION}/fastly_v${FASTLY_CLI_VERSION}_SHA256SUMS" -o sha256sums \
  && dlsha=$(shasum -a 256 fastly.tar.gz | cut -d " " -f 1) && expected=$(cat sha256sums | awk -v pat="$dlsha" '$0~pat' | cut -d " " -f 1) \
  && if [[ "$dlsha" != "$expected" ]]; then echo "shasums don't match" && exit 1; fi

RUN tar -xzf fastly.tar.gz --directory /usr/bin && rm fastly.tar.gz

RUN adduser fastly
USER fastly

WORKDIR /app
ENTRYPOINT ["/usr/bin/fastly"]
CMD ["--help"]

# docker build -t fastly/cli/node . -f ./Dockerfile-node
# docker run -v $PWD:/app -it -p 7676:7676 fastly/cli/node compute serve --addr="0.0.0.0:7676"
