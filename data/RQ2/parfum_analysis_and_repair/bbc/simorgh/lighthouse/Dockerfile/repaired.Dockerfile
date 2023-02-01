FROM node:12-alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --no-cache chromium

RUN npm install -g @lhci/cli@0.6.x && npm cache clean --force;

COPY . .

CMD ["lhci", "autorun", "--config=./lighthouse/lighthouserc.js"]