FROM node:8.9.0

EXPOSE 3039
ENV PORT=3039

RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

RUN mkdir -p /usr/src/app/src/web_client && rm -rf /usr/src/app/src/web_client

COPY ./src/web_client/package.json ./src/web_client/

RUN cd ./src/web_client && npm install && npm cache clean --force;

COPY . .

WORKDIR /usr/src/app/src/web_client

CMD [ "npm", "start"]
