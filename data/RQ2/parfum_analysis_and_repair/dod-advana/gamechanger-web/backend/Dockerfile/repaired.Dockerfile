FROM node:14
RUN apt-get update && apt-get install --no-install-recommends -y vim && apt-get install --no-install-recommends -y postgresql && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/app
COPY package.json /usr/src/app
COPY .npmrc /usr/src/app
RUN npm install -g nodemon \
    && npm install -g sequelize-cli \
    && npm install -g jest \
    && npm install && npm cache clean --force;
COPY . /usr/src/app
EXPOSE 8990
CMD ./start.sh
# CMD sleep 600000
