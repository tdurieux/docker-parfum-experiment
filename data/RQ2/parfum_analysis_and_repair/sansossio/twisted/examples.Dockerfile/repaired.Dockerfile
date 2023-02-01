FROM node:carbon
WORKDIR /app
COPY ./package*.json ./
RUN npm i && npm cache clean --force;
COPY . .
CMD ["npm", "run", "example"]
