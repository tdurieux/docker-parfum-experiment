FROM node:10.14.2
WORKDIR /app
COPY package*.json ./
RUN npm install --production && npm cache clean --force;
COPY . .
RUN npm run build
EXPOSE 15100-15109 15001
CMD [ "node", "--expose-gc" , "build/app"]