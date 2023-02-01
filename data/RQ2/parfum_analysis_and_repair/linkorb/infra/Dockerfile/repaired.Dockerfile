FROM node:current-slim

WORKDIR /app
COPY . /app

RUN apt-get update
RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;

# RUN make build

EXPOSE 80

ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

CMD ["apachectl", "-D", "FOREGROUND"]
