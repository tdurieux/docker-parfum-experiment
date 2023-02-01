FROM node:boron

COPY . /opt/anon
WORKDIR /opt/anon

RUN apt-get update \
 && apt-get install --no-install-recommends --yes build-essential libicu-dev \
 && npm install \
 && ln -s /opt/anon/anon.js /usr/bin/anon && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

CMD ["anon"]

