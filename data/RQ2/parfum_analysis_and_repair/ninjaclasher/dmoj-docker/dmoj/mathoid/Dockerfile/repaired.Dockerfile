FROM node:10.21.0

RUN npm install mathoid && \
    ln -sfv /node_modules/mathoid/app.js /node_modules/app.js && npm cache clean --force;

EXPOSE 10044
WORKDIR /node_modules/mathoid
CMD /node_modules/mathoid/server.js
