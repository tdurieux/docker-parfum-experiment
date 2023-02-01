FROM node:10.15-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
  python \
  libicu-dev \
  libxml2-dev \
  libexpat1-dev \
  build-essential \
  git \
  make && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

WORKDIR /app

EXPOSE 8081
VOLUME ["/app"]
CMD ["/app/dev/docker-entrypoint.sh"]
