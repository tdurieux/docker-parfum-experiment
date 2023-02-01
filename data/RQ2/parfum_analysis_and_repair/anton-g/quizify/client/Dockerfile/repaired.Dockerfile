# stage: 1
FROM node:8 as react-build
WORKDIR /app
COPY . ./
RUN npm install && npm cache clean --force;
RUN npm rebuild node-sass
RUN npm run build
RUN npm install -g serve && npm cache clean --force;

EXPOSE 5000

ENTRYPOINT [ "serve" ]
CMD ["-s", "dist"]
