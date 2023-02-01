FROM cypress/base

WORKDIR /var/www/web/test

COPY . .

RUN npm install -g cypress && npm cache clean --force;
RUN npm ci
