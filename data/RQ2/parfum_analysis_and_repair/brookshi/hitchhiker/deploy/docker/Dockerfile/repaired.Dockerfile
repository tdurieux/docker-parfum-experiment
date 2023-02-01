FROM node:7.10
MAINTAINER brook.shi iwxiaot@gmail.com

RUN apt-get update

# code folder
RUN mkdir -p /usr/src && rm -rf /usr/src
WORKDIR /usr/src
RUN git clone -b release https://github.com/brookshi/Hitchhiker.git
WORKDIR /usr/src/Hitchhiker

# npm install -g
RUN npm install -g pm2 yarn gulp-cli typescript@2.3.3 && npm cache clean --force;
RUN npm install gulp -D && npm cache clean --force;
RUN npm install typescript@2.3.3 --save && npm cache clean --force;

# npm install
RUN npm install && npm cache clean --force;

RUN cd client && npm install && npm cache clean --force;

# gulp build
RUN gulp release --prod

WORKDIR /usr/src/Hitchhiker/build
# start mail
EXPOSE 8080
CMD ["pm2-docker", "index.js"]
