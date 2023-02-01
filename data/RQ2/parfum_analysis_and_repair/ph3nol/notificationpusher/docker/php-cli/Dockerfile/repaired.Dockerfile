FROM php:7.4-cli

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl git && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www

#make it running
ENTRYPOINT ["tail", "-f", "/dev/null"]
