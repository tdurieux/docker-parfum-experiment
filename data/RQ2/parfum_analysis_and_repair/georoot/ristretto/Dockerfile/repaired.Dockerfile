FROM node:boron
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;
COPY . /usr/src/app

RUN apt-get update

RUN apt-get -y --no-install-recommends install openssh-client && rm -rf /var/lib/apt/lists/*;
RUN ssh-keygen -q -t rsa -N '' -f /id_rsa

RUN apt-get -y --no-install-recommends install nginx && rm -rf /var/lib/apt/lists/*;
RUN rm /etc/nginx/sites-enabled/default
COPY config/nginx/default /etc/nginx/sites-enabled/
RUN service nginx start

EXPOSE 8090
EXPOSE 80
CMD [ "node","bin/ristretto.js"]
