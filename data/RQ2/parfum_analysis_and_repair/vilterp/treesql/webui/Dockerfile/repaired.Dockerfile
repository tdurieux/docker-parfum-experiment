FROM node:6.10

COPY . webui
WORKDIR webui
RUN npm install && npm cache clean --force;
RUN npm run build

RUN npm install -g http-server && npm cache clean --force;

EXPOSE 8080

CMD http-server build -p 8080 -d false
