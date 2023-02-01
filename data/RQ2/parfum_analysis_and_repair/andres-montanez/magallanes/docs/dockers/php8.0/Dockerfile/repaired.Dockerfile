FROM ubuntu:21.10

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y vim curl git unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y php8.0-cli php8.0-zip php8.0-curl php8.0-xml php8.0-mbstring php8.0-xdebug && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /home/magephp
