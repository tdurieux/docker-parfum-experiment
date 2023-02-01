FROM mhart/alpine-node:9
RUN mkdir www/
WORKDIR www/
RUN apk add --no-cache --update inotify-tools git
ADD . .
RUN npm install && \
 npm run build && npm cache clean --force;
CMD npm run host