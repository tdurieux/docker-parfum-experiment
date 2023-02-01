# For Production
FROM nginx:latest

# build node package
RUN apt update && apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash

RUN npm install -g yarn && npm cache clean --force;
RUN mkdir /code /code/public /code/src
COPY public /code/public
COPY src /code/src
COPY package.json yarn.lock /code/
RUN cd /code && find . && yarn install && yarn run build && yarn cache clean;

# TODO: uninstall node

RUN mkdir /app
RUN cp -R /code/build/* /app/

COPY ./nginx/react/nginx.conf /etc/nginx/nginx.conf
