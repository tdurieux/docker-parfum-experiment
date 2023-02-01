FROM ubuntu
RUN apt update && apt install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]