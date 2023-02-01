FROM node

# Prepare postgraphile

WORKDIR /usr/relay-modern-boilerplate/postgraphile

COPY package.json package-lock.json ./
RUN npm i && npm cache clean --force;

COPY . .

# TODO: production build steps
