FROM node:latest
RUN mkdir -p /code
WORKDIR /code
ADD . /code
RUN npm install -g -s --no-progress yarn && \
    yarn && \
    yarn run build && \
    yarn cache clean && npm cache clean --force;
CMD [ "npm", "start" ]
EXPOSE 8080
