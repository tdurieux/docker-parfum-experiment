# WORKDIR, COPY and ADD example
FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends apache2 -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /var/www/html/
COPY index.html .
ADD https://www.docker.com/sites/default/files/d8/2019-07/Moby-logo.png ./logo.png
CMD ["ls"]
