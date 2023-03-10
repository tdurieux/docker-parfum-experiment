FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -yq upgrade && \
    apt-get -yq --no-install-recommends install \
			nodejs \
			nodejs-legacy \
			npm \
			curl && \
    npm install socket.io && \
    npm install xml2json && \
    npm install string.prototype.endswith && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/coreos/etcd/releases/download/v2.0.5/etcd-v2.0.5-linux-amd64.tar.gz -o etcd-v2.0.5-linux-amd64.tar.gz && \
  tar xzvf etcd-v2.0.5-linux-amd64.tar.gz && rm etcd-v2.0.5-linux-amd64.tar.gz

ADD dashboard /dashboard
ADD start.sh /start.sh

EXPOSE 8000
CMD /start.sh
