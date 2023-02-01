FROM iojs:3.3.0

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY package.json /usr/src/app/
 \
RUN npm install && npm cache clean --force; ONBUILD
ONBUILD COPY . /usr/src/app

CMD [ "npm", "start" ]
