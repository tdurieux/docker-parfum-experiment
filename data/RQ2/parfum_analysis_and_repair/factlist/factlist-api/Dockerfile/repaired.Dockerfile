FROM node:alpine
WORKDIR /
RUN apk add --no-cache --update git openssh
COPY package.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 4000
CMD ["npm", "run", "docker"]
