FROM node:7.8.0

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY public public
COPY src src

EXPOSE 3000
ENTRYPOINT ["npm", "start"] # dev build

#RUN npm run build --production
#RUN npm install -g serve

#ENTRYPOINT ["serve", "-s", "build"]
