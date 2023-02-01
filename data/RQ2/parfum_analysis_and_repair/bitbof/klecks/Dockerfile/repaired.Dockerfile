FROM node

COPY . /var/www
WORKDIR /var/www

RUN npm install serve -g && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm run lang:build
RUN npm run build
RUN npm run build:help

ENTRYPOINT ["npx", "serve", "dist"]
EXPOSE 3000
