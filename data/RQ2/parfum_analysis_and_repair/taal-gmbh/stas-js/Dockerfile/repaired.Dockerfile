FROM node:12.18.1
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production && npm cache clean --force;
COPY . .
CMD [ "npm", "test" ]