FROM debian:11-slim
RUN apt-get update && apt-get install --no-install-recommends dnsdist supervisor inotify-tools -y && rm -rf /var/lib/apt/lists/*;
COPY bin/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh
COPY supervisord.conf /etc/supervisor/supervisord.conf
EXPOSE 8053
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf", "-u", "root"]