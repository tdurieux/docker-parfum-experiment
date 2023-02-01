FROM node:8

RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY package.json /usr/src/app/package.json
RUN npm install --silent && npm cache clean --force;
RUN npm install react-scripts@1.1.1 -g --silent && npm cache clean --force;

# start app
CMD ["npm", "start"]