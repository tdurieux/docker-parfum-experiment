FROM quay.io/footloose/ubuntu18.04

RUN apt-get update && apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;
COPY index.html /var/www/html

RUN systemctl enable apache2.service

EXPOSE 80
