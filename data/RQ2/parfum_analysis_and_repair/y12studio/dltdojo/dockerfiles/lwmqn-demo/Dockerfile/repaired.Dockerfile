FROM y12docker/dltdojo-bex
# https://github.com/lwmqn/lwmqn-demo
# https://github.com/y12studio/lwmqn-demo
RUN apk --update --no-cache add nodejs && \
    apk add --no-cache --virtual .builddeps build-base python musl-dev && \
    git clone --depth=1 https://github.com/y12studio/lwmqn-demo.git /lwmqn-demo && \
    cd /lwmqn-demo && npm install && \
    apk --no-cache --purge del .builddeps && npm cache clean --force;
WORKDIR /lwmqn-demo
ADD package.json .
RUN npm install && npm cache clean --force;
ADD start.sh initbtc.sh /
RUN chmod +x /*.sh
ADD dltdojo.js app/dltdojo.js
