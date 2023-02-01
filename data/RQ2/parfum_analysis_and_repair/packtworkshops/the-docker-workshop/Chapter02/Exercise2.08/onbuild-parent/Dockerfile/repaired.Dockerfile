# ONBUILD example
FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends apache2 -y && rm -rf /var/lib/apt/lists/*;
ONBUILD COPY *.html /var/www/html
EXPOSE 80
ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
