FROM node:9.5

# Set work directory to /www
WORKDIR /www

# Copy app source
COPY . /www

RUN cd /www && npm install && npm cache clean --force;

# set env variables

CMD [ "npm", "run", "startROUTINE" ]