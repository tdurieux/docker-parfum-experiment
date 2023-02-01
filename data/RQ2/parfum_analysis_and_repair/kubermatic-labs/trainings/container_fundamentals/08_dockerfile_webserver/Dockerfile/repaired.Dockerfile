FROM ubuntu:20.10
RUN apt-get update && apt-get install --no-install-recommends apache2 -y && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY index.html /var/www/html/index.html
CMD [ "apache2ctl", "-DFOREGROUND" ]