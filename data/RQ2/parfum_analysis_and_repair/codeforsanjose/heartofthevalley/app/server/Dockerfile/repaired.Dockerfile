FROM node:alpine
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
COPY ./ ./
RUN npm i && npm cache clean --force;
CMD ["npm", "run", "start"]