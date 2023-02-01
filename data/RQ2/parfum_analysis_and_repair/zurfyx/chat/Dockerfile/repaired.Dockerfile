FROM node:boron

RUN mkdir -p /app
WORKDIR /app

COPY . /app
RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD ["npm", "start"]