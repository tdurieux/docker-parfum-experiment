FROM node:13
WORKDIR /usr/src/app

COPY package*.json tsconfig*.json ./
RUN npm install && npm cache clean --force;

COPY src/ src/
RUN npm run build
RUN rm -r src

CMD ["npm", "run", "start:prod"]
