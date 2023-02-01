FROM node

WORKDIR /app

ADD package.json /app
ADD package-lock.json /app

RUN npm install && npm cache clean --force;

COPY ./ /app

RUN npm run build --production

RUN npm install -g serve && npm cache clean --force;
CMD serve -s build

EXPOSE 3000
