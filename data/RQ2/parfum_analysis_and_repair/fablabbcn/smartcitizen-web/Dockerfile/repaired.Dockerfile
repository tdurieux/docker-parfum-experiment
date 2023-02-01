FROM node:8.11.2

RUN groupadd -g 999 deployer && \
  useradd -r -u 999 -g deployer deployer

WORKDIR /home/deployer

RUN chown -R deployer. .
USER deployer

COPY package*.json ./
COPY bower.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080
EXPOSE 3001
CMD [ "./node_modules/.bin/gulp","serve" ]
