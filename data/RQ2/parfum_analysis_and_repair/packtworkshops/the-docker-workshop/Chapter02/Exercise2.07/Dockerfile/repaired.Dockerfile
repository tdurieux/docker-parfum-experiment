# EXPOSE & HEALTHCHECK example
FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends apache2 curl -y && rm -rf /var/lib/apt/lists/*;
HEALTHCHECK CMD curl -f http://localhost/ || exit 1
EXPOSE 80
ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
