# Base image
FROM node:10.15

# Configure environment
ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  DEBIAN_FRONTEND=noninteractive

# Update npm
RUN npm i -g npm && npm cache clean --force;
RUN npm cache clean --force -f

# Install Chainode
RUN npm init --force
RUN npm install chainode && npm cache clean --force;
WORKDIR /node_modules/chainode

# Run Chainode peer
CMD npm start
