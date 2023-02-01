FROM node:12.16

# install os level packages
RUN apt-get update && apt-get -y --no-install-recommends install \
  curl \
  vim \
  wget && rm -rf /var/lib/apt/lists/*;

# install node dependencies
WORKDIR /var/app
COPY package*.json ./
RUN npm i && npm cache clean --force;

CMD ["npm", "run", "start"]
