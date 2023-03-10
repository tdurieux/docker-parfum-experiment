FROM openresty/openresty:alpine
RUN apk add --no-cache --update \
    sed \
    && rm -rf /var/cache/apk/*
COPY ./ /opt/wolf/agent
WORKDIR /opt/wolf/agent
EXPOSE 12182
ENTRYPOINT ["sh", "./entrypoint.sh"]
