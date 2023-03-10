FROM node:11.4.0
LABEL maintainer "Dan Melton <dan@civicsoftwarefoundation.org>"

RUN apt-get update -y && apt-get install --no-install-recommends -y gdal-bin && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY package.json .
COPY package-lock.json .

RUN npm install && npm cache clean --force;
COPY . /app

COPY wait-for-it.sh .

EXPOSE 3000
CMD ["npm", "run", "seedandrun"]
