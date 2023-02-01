FROM mhart/alpine-node
RUN mkdir -p /code
ADD package.json /tmp/package.json
RUN cd /tmp && npm install && npm cache clean --force;
RUN cp -a /tmp/node_modules /code
RUN npm install express && npm cache clean --force;
RUN npm install deepstream.io-client-js && npm cache clean --force;
WORKDIR /code
ADD . /code
CMD ["npm","start"]
