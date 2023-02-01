FROM docker
RUN apk add --no-cache nodejs npm && npm i express && npm cache clean --force;
COPY review-proxy.js /
