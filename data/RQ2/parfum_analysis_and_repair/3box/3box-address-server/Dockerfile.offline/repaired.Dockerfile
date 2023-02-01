FROM node:10

RUN npm install -g serverless && npm cache clean --force;

WORKDIR /3box-address-server

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;

COPY src ./src
COPY serverless.yml webpack.config.js .babelrc ./

EXPOSE 3000

CMD serverless offline start --noEnvironment --printOutput
