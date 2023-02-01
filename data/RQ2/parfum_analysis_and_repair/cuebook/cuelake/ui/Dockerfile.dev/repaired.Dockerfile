# dev environment
FROM node:14-alpine
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY ./package.json /app/package.json
RUN cat package.json
RUN npm install && npm cache clean --force;
RUN which npm
EXPOSE 3000
CMD ["/usr/local/bin/npm", "start"]
