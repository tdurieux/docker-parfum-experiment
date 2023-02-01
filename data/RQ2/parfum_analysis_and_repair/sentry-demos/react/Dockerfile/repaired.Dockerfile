FROM node:14.2.0
COPY ./build ./app
WORKDIR /app
RUN npm install -g serve && npm cache clean --force;
CMD serve -s . -l $PORT