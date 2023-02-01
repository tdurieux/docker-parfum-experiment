FROM node:6.14.2-slim
RUN apt-get update && apt-get install --no-install-recommends -y zip && apt-get install --no-install-recommends -y subversion && rm -rf /var/lib/apt/lists/*;
WORKDIR /srv/kai
COPY . .
EXPOSE 8080
RUN npm install && npm run ts && npm run downloaddata && npm cache clean --force;
RUN npm install http-server -g && cat LICENSE && npm cache clean --force;
CMD ["http-server", "./www"]