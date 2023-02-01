FROM node:latest

RUN echo "source /var/www/typeorm-api/docker/export.sh" >> /etc/bash.bashrc

RUN apt-get update \
    && apt-get install --no-install-recommends -y tzdata \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash
RUN npm i -g typescript ts-node && npm cache clean --force;

WORKDIR /var/www/typeorm-api

ADD . /var/www/typeorm-api

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD ["docker/start.sh"]
