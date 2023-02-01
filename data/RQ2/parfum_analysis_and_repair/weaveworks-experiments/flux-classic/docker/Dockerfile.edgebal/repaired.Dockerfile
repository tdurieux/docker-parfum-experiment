FROM nginx
RUN apt-get update && apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/conf.d/supervisord.conf"]
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./nginx.tmpl ./nginx.conf ./unavailable.html /home/flux/
COPY ./balagent /home/flux/balagent
