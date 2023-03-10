FROM node:18-alpine3.15

LABEL maintainer="pedroperegrinaa"

WORKDIR /src

COPY . .

RUN npm install -g pnpm && npm cache clean --force;
RUN pnpm install

CMD ["pnpm", "start"]