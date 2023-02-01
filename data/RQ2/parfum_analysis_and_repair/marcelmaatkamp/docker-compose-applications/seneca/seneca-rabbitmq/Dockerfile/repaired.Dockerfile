FROM node
WORKDIR /project
COPY conf/package.json package.json
COPY src/start.js start.js
RUN npm install && npm cache clean --force;
CMD ["node","start.js"]
