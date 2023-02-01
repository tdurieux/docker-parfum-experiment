FROM brettt89/silverstripe-web
RUN apt-get update && apt-get install --no-install-recommends -y \
    zip \
    unzip \
    wget \
    mariadb-client \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;

EXPOSE 80
EXPOSE 8983

CMD ["apache2-foreground"]
