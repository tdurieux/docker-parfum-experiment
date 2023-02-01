FROM node
ADD app /app
WORKDIR /app
RUN npm install && npm cache clean --force;
ENV NODE_TLS_REJECT_UNAUTHORIZED 0
CMD node index.js
