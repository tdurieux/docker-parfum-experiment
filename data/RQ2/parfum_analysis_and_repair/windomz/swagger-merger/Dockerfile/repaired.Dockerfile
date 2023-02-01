FROM node:alpine

RUN npm install -g swagger-merger watch && npm cache clean --force;

CMD ["swagger-merger"]
