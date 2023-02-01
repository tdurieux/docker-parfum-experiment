FROM node
RUN mkdir -p /var/build/
WORKDIR /var/build/
RUN npm install -g bower && npm cache clean --force;
CMD bower install --allow-root