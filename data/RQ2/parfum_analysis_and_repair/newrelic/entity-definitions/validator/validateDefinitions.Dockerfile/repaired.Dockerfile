FROM node:14.19.1-alpine
WORKDIR /scripts
VOLUME  /definitions
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install && npm cache clean --force;
COPY . .
CMD ["npm", "run", "check"]
