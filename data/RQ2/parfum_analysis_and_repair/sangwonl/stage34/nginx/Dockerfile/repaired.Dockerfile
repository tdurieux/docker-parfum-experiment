FROM ubuntu:trusty
MAINTAINER Sangwon Lee (gamzabaw@gmail.com)

RUN apt-get update && apt-get -y --no-install-recommends install nginx && rm -rf /var/lib/apt/lists/*;

WORKDIR /etc/nginx

ENTRYPOINT ["nginx"]

EXPOSE 80
EXPOSE 443