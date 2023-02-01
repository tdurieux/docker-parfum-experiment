FROM debian:stable-slim

MAINTAINER xiayesuifeng "xiayesuifeng@firerain.me"

WORKDIR /goblog

ENV GOBLOG_WEB_PATH /goblog/web

COPY goblog /goblog

RUN apt-get update -qq && apt-get install --no-install-recommends -y -qq ca-certificates && rm -rf /var/lib/apt/lists/*;

EXPOSE 80 443 8080

VOLUME /goblog/data

ENTRYPOINT ["./goblog"]
CMD ["-c","./config.json"]