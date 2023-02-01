FROM node:14-alpine
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY . .
RUN npm install --production --silent && npm cache clean --force;
EXPOSE 8081
CMD npm start