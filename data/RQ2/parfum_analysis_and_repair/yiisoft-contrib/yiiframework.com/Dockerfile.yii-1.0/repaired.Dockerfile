# PHP

FROM php:7.0-cli

# System packages

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Code

ADD . /code
WORKDIR /code

ENTRYPOINT ["rm", "-rf", "api-1.0"]
