# ubuntu

FROM ubuntu
MAINTAINER molin
WORKDIR /root
COPY ./bin/* /bin/
EXPOSE 17717/tcp 17717/udp
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

