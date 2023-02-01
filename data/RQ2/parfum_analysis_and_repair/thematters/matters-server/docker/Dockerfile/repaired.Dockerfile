FROM node:16

# install os level packages
RUN apt-get update && apt-get -y --no-install-recommends install curl \
  postgresql-client \
  vim \
  wget && rm -rf /var/lib/apt/lists/*;

# install dependencies
WORKDIR /var/app
COPY package*.json ./
RUN npm install --force && npm cache clean --force;

CMD ["npm", "run", "start"]
