FROM node:argon

ENV cachebust=840762987412734

RUN npm install gulp -g && npm cache clean --force;
RUN npm install bower -g && npm cache clean --force;

# Create app directory
RUN mkdir -p /usr/src/app/ && rm -rf /usr/src/app/
WORKDIR /usr/src/app/

# Install app dependencies
COPY . /usr/src/app/

RUN npm install && npm cache clean --force;
RUN cd client
RUN bower install --allow-root
RUN cd ..

RUN gulp build

EXPOSE 3000

CMD [ "node", "server/server.js" ]
