FROM node:16-alpine

ENV DEBUG expresso:*,gg:*

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
COPY ["./package.json", "./package-lock.json", "/usr/src/app/"]
COPY ["./src", "./tsconfig.json", "/usr/src/app/"]
WORKDIR /usr/src/app

RUN npm i && npm cache clean --force;
RUN npm run build

EXPOSE 3000

ENTRYPOINT [ "npm", "start" ]
