FROM node:8-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;

COPY . .

ENV DEBUG=stepfunctions-local:*
EXPOSE 4584
ENTRYPOINT ["./bin/stepfunctions-local.js"]

CMD ["start"]