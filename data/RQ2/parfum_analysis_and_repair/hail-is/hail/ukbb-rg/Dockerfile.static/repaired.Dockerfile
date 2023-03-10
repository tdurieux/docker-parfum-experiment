FROM {{ docker_prefix }}/ubuntu:20.04

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y nginx && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/sites-enabled/default
ADD static.nginx.conf /etc/nginx/conf.d

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["nginx", "-g", "daemon off;"]
