FROM jwilder/nginx-proxy

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server apache2 supervisor && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord"]
