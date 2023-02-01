FROM node:11.15

RUN mkdir /app
WORKDIR /app

# Install Mongo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
RUN echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" > /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN apt-get update
RUN apt-get install -y mongodb-org

COPY ./package.json ./package-lock.json ./
RUN npm ci

EXPOSE 80
CMD npm start
