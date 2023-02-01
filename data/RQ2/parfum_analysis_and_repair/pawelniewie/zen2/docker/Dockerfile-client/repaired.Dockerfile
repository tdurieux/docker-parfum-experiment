FROM node:7

ENV app /app
RUN mkdir $app
WORKDIR $app

ONBUILD COPY .. $app

 \
RUN npm install && npm cache clean --force; ONBUILD

CMD [ "npm", "start" ]