FROM node:8.9.1-alpine

WORKDIR /root/user-api

COPY . .

RUN npm install && npm test && npm cache clean --force;

EXPOSE 8082

CMD ["run", "start"]
ENTRYPOINT ["npm"]
