FROM node:13

WORKDIR /app
ADD  ./package-lock.json ./package.json /app/
RUN npm ci

ADD ./ /app/