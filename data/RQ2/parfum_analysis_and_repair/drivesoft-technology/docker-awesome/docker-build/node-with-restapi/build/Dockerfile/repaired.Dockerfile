FROM node:8.9.4
LABEL Eakkabin Jaikeawma <eakkabin@codestep.io>

# COPY . /usr/src/app
# WORKDIR /usr/src/app

RUN npm install nodemon@^1.15.0 -g && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]