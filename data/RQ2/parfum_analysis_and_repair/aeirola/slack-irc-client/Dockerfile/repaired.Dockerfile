FROM node:6
RUN npm install -g slack-irc-client && npm cache clean --force;
ADD bin/start.sh /start.sh
ENTRYPOINT /start.sh
