FROM node:10-slim
ADD ./package.json /app/
RUN cd /app && npm install --production && npm cache clean --force;
ADD . /app/
WORKDIR /app
EXPOSE 8000
CMD ["node", "worker.js"]
