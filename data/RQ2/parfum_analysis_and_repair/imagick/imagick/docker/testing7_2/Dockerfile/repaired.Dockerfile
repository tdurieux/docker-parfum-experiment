FROM debian:9

USER root

# Get Debian up-to-date
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git \
    mariadb-client wget curl \
    ca-certificates lsb-release apt-transport-https gnupg bsdmainutils && rm -rf /var/lib/apt/lists/*;

# Install 3rd party PHP 7.2 packages
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/php.list
RUN curl -f -L https://packages.sury.org/php/apt.gpg | apt-key add -

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y php7.2 php7.2-common php7.2-cli php7.2-fpm \
    php7.2-mysql php7.2-curl php7.2-xml php7.2-mbstring \
    php7.2-intl php7.2-redis php7.2-zip php7.2-sqlite \
    php7.2-imagick && rm -rf /var/lib/apt/lists/*;

# Make the default directory you
WORKDIR /var/app

# Run the process that this container will serve

CMD tail -f /var/app/docker/testing7_2/README.md
