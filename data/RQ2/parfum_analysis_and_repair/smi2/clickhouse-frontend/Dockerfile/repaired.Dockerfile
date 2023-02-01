FROM node:6.7.0

RUN npm install -g bower && npm update -g bower && \
    npm install -g gulp && npm update -g gulp && npm cache clean --force;

COPY . /app

WORKDIR /app

RUN npm install && \
    bower install --allow-root && \
    gulp build && npm cache clean --force;

EXPOSE 3000

CMD ["gulp", "serve:dist"]
