FROM node:14.16

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;
RUN npm install -g @angular/cli && npm cache clean --force;

COPY . .

CMD ng serve --host 0.0.0.0
