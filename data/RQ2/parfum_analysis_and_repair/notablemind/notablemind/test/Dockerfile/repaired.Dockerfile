FROM jaredly/node

WORKDIR /deps
ADD package.json /deps/
RUN npm install && npm cache clean --force;
WORKDIR /app
ADD . /app
RUN rm -rf /app/node_modules
RUN mv /deps/node_modules /app
RUN /nodejs/bin/npm test

