FROM debian

RUN set -e -x; \
  groupadd -g 1337 www; \
  useradd -g 1337 -u 1337 -m www


RUN apt-get update
RUN apt-get install --no-install-recommends -y curl gnupg && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ADD app /app
WORKDIR /app
RUN npm install && npm cache clean --force;

RUN chown -R root:root /app
RUN chmod -R 0755 /app
