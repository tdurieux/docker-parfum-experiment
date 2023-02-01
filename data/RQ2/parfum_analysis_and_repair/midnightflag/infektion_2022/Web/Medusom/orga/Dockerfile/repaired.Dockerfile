FROM php:7.3-apache

EXPOSE 80
EXPOSE 443
EXPOSE 4490

RUN apt-get update
RUN apt-get upgrade -y

# Installations des basiques
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --fix-missing -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libxml2-dev libbz2-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libsqlite3-dev libsqlite3-0 mariadb-client curl exif ftp mailutils postfix && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;

# Installation de packages additionnels
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install --fix-missing netcat curl nano screen git && rm -rf /var/lib/apt/lists/*;
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Installation de python
RUN apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir websockets
COPY chat.py /chat.py
RUN chmod +x /chat.py

# Installation du serveur web
RUN rm -rf /etc/apache2/sites-enabled/*
COPY site.conf /etc/apache2/sites-enabled/site.conf
#ADD html /var/www/html
RUN a2enmod rewrite

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer self-update --2

# Installation du script de démarrage
ADD entrypoint.sh /atlas.sh
RUN chmod +x /atlas.sh
CMD ["/atlas.sh"]