FROM node:18 as node
WORKDIR /
COPY . .
RUN npm ci --only=production \
    && npm run minify \
    && sed -i '' server/static/**/*


FROM golang:1.18-bullseye

LABEL maintainer="git@albertyw.com"
EXPOSE 5003
HEALTHCHECK --interval=5s --timeout=3s CMD bin/healthcheck.sh || exit 1
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set up directory structures
WORKDIR /root/gocode/src/github.com/albertyw/reaction-pics
ENV GOPATH /root/gocode
RUN mkdir -p .
COPY . .
COPY --from=node ./server/static ./server/static

# App-specific setup
RUN make bins

CMD ["bin/start.sh"]
