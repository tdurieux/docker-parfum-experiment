FROM stream.place/sp-node

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y nginx && \
  rm -rf /var/lib/apt/lists/*

ADD nginx.conf /etc/nginx/nginx.conf

CMD ["nginx"]
