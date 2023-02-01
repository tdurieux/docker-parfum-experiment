FROM nvidia/cuda:11.4.2-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /var/www/app

COPY . .

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget gnupg \
    && cd /var/www/app && rm -rf /var/lib/apt/lists/*;

RUN wget -O node_setup.sh https://deb.nodesource.com/setup_14.x \
    && . ./node_setup.sh \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install \
    && npm run build:prod && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

CMD ["npm", "run", "start"]
