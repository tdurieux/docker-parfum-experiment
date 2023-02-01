FROM node:alpine
ENV CI=true

WORKDIR /app
COPY package.json .
RUN npm install --only=prod && npm cache clean --force;
COPY . .

CMD ["npm", "start"]