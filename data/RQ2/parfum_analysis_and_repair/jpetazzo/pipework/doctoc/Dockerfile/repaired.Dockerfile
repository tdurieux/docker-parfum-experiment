FROM node
RUN npm install -g doctoc && npm cache clean --force;
ENTRYPOINT ["doctoc"]
