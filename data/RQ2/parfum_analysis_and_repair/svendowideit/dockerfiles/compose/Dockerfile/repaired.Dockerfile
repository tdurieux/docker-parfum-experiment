FROM python:2.7-slim

MAINTAINER Sven Dowideit <SvenDowideit@home.org.au>

# Sven needed Make, so adding the tools I use most often
RUN apt-get update \
	&& apt-get install --no-install-recommends -yq make vim-tiny git curl && rm -rf /var/lib/apt/lists/*;

# Install docker-compose with dependencies
RUN pip install --no-cache-dir docker-compose

# This image is made to run docker-compose
ENTRYPOINT ["docker-compose"]

# put the docker-compose.yml into the /app dir
WORKDIR /app

# Print version as default
CMD ["--version"]
