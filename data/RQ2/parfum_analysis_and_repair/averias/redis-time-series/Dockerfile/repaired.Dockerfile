FROM node:12
WORKDIR '/app'
COPY ./package.json ./
RUN npm install && npm cache clean --force;
COPY ./ ./
CMD ["/bin/bash", "-c", "sleep infinity"]
