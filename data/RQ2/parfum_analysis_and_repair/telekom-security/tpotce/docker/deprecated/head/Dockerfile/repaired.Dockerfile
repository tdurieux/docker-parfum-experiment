FROM alpine:3.15
#
# Setup env and apt
RUN apk -U add \
            curl \
            git \
            nodejs \
            #nodejs-npm && \
            npm && \
#
# Get and install packages
    mkdir -p /usr/src/app/ && \
    cd /usr/src/app/ && \
    git clone https://github.com/mobz/elasticsearch-head . && \
    git checkout 2d51fecac2980d350fcd3319fd9fe2999f63c9db && \
    npm install http-server && \
    sed -i "s#\"http\:\/\/localhost\:9200\"#window.location.protocol \+ \'\/\/\' \+ window.location.hostname \+ \'\:\' \+ window.location.port \+ \'\/es\/\'#" /usr/src/app/_site/app.js && \
#
# Setup user, groups and configs
    addgroup -g 2000 head && \
    adduser -S -H -s /bin/ash -u 2000 -D -g 2000 head && \
    chown -R head:head /usr/src/app/ && \
#
# Clean up
    apk del --purge git && \
    rm -rf /root/* && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && npm cache clean --force; && rm -rf /usr/src/app/
#
# Healthcheck
HEALTHCHECK --retries=10 CMD curl -s -XGET 'http://127.0.0.1:9100'
#
# Start elasticsearch-head
USER head:head
WORKDIR /usr/src/app
CMD ["node_modules/http-server/bin/http-server", "_site", "-p", "9100"]
