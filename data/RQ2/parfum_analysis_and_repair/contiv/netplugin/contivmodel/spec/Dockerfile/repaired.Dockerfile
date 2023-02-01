FROM node:alpine

RUN npm install -g raml2html && npm cache clean --force;

RUN mkdir /contiv

WORKDIR /contiv

ENTRYPOINT ["raml2html"]
