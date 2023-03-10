FROM node:9.5

# Set work directory to /www
WORKDIR /www

# Copy app source
COPY . /www

RUN cd /www && npm install && npm cache clean --force;

# set env variables
ENV NODE_ENV development
ENV PORT 3000

# expose the port to outside world
EXPOSE 3000
EXPOSE 3001

CMD [ "npm", "run", "startAPP" ]