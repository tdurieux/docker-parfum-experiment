FROM node:14-alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["npm", "run", "start"]