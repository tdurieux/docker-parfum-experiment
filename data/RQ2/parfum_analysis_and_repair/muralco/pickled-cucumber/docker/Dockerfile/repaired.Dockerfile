FROM node:16.13.0

WORKDIR /usr/src

COPY ["package.json", "package-lock.json", "/usr/src/"]

RUN npm i --loglevel=warn --porcelain --progress=false && npm cache clean --force;

RUN npm i --no-save --loglevel=warn --porcelain --progress=false mongodb@2.2.27 && npm cache clean --force;

COPY ["tsconfig.json", "docker/wait.sh", "/usr/src/"]

CMD ./wait.sh && TS_NODE_FILES=true ./node_modules/.bin/cucumber-js --require-module ts-node/register -r src/test.ts -t "not @ignore"
