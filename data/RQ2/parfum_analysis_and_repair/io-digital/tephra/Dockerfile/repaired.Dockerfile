FROM node:lts-buster

ENV TRAVIS 1

RUN apt-get update -y && apt-get install -y --no-install-recommends freeradius-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


RUN mkdir /app
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY ./ ./

CMD ["npm", "test"]
