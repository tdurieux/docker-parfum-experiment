FROM node:9.6.1

RUN mkdir client/usr/src/app && rm -rf client/usr/src/app
WORKDIR /client/usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY package.json /client/usr/src/app/package.json
RUN npm install --silent && npm cache clean --force;
RUN npm install react-scripts@1.1.1 -g --silent && npm cache clean --force;

CMD ["npm", "start"]