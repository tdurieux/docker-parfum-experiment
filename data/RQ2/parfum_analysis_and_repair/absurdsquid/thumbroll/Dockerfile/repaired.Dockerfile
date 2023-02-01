FROM node
RUN npm install -g webpack && npm cache clean --force;
RUN mkdir /app
RUN mkdir /app/server
RUN mkdir /app/client
RUN mkdir /app/client/desktop
ADD server/. /app/server
ADD client/desktop/. /app/client/desktop
ADD package.json /app
ADD Dockerfile /app

WORKDIR /app
RUN npm install && npm cache clean --force;

WORKDIR /app/client/desktop
RUN webpack

WORKDIR /app
EXPOSE 80
CMD ["npm", "start"]