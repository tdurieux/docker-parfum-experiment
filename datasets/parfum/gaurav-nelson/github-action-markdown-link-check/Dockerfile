FROM node:lts-alpine
RUN apk add --no-cache bash>5.0.16-r0 git>2.26.0-r0
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
