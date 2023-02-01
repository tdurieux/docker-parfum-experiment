FROM node:lts-alpine
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm install --silent && npm cache clean --force;
COPY . ./
RUN npm test
CMD ["npm", "start"]
