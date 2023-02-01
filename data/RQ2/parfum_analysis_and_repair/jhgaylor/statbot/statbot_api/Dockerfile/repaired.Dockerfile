FROM iojs:onbuild
MAINTAINER Jake Gaylor <jhgaylor@gmail.com>

ADD . /statbot_api
WORKDIR /statbot_api

RUN npm install && npm cache clean --force;

CMD npm start
