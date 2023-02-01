FROM node:current

RUN mkdir -p /app
WORKDIR /app

COPY package.json .
RUN npm install -g npm@latest && npm cache clean --force;
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 4200
CMD ["npx", "ng", "serve", "--host", "0.0.0.0", "--port", "4200"]
