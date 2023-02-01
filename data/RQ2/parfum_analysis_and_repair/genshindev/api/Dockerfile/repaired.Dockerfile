FROM node:12
WORKDIR /usr/src/app

ARG PORT=5000

RUN npm install -g pnpm && npm cache clean --force;

COPY package*.json ./
COPY pnpm-lock.yaml ./
RUN pnpm install

COPY . .
RUN npm run build

EXPOSE ${PORT}
CMD ["npm", "run", "start"]
