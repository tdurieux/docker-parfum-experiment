FROM y12docker/dltdojo-ethgo
# https://github.com/carsenk/explorer
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.5/main" >> /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories &&\
    apk upgrade --update
RUN apk --update --no-cache add nodejs git &&\
    git clone --depth=1 https://github.com/carsenk/explorer.git /opt/carexp && \
    npm install -g bower http-server && npm cache clean --force;
WORKDIR /opt/carexp
RUN npm install && bower install --allow-root && npm cache clean --force;
ADD start.sh /start.sh
RUN chmod a+x /start.sh
ENTRYPOINT []
