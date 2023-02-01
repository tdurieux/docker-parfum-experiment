FROM node:14-alpine

WORKDIR /app
COPY ./ ./

RUN npm install && npm cache clean --force;
RUN npm run build

EXPOSE 3000

COPY ./start.sh ./
RUN chmod +x ./start.sh

CMD ["sh", "./start.sh"]
