FROM node:16

RUN npm install -g alks && npm cache clean --force;

ENTRYPOINT ["/usr/local/bin/alks"]
CMD ["help"]