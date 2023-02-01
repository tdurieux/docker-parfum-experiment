FROM node:14-alpine

WORKDIR /app
COPY . /app
RUN npm install && npm run build && npm cache clean --force;

EXPOSE 10086
CMD ["npm", "start"]
