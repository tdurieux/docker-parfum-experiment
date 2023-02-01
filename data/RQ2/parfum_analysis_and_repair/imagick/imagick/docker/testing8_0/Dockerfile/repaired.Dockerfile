FROM debian:9

USER root

# Get Debian up-to-date
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git \
    mariadb-client wget curl \
    ca-certificates lsb-release apt-transport-https gnupg bsdmainutils && rm -rf /var/lib/apt/lists/*;


RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/php.list
RUN curl -f -L https://packages.sury.org/php/apt.gpg | apt-key add -

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y php8.0 php8.0-common php8.0-cli php8.0-fpm \
    php8.0-mysql php8.0-curl php8.0-xml php8.0-mbstring \
    php8.0-intl php8.0-redis php8.0-zip php8.0-sqlite \

    php8.0-imagick && rm -rf /var/lib/apt/lists/*;

# Make the default directory you
WORKDIR /var/app

# Run the process that this container will serve

CMD tail -f /var/app/docker/testing8_0/README.md
