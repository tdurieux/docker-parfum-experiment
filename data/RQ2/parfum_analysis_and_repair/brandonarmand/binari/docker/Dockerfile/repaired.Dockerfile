FROM node:12.18.3-buster


#copy the content of current directory to /app inside container
COPY . /Binari

WORKDIR /Binari

RUN npm install && npm cache clean --force;
RUN npm install -g serve && npm cache clean --force;

RUN npm run build

EXPOSE 5000

ENTRYPOINT [ "serve", "-s", "build/" ]