FROM node:10-jessie as build

# install and cache app dependencies
COPY package*.json /build/

WORKDIR /build

RUN ls && \
    npm install && npm cache clean --force;

# add app
COPY . /build/

RUN ls && npm run build

EXPOSE 9000

CMD ["npm", "run", "prod"]