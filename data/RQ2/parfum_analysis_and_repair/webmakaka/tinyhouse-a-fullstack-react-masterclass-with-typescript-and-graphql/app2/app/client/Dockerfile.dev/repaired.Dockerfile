FROM node:lts-alpine3.12

WORKDIR /app
COPY package.json ./

# without next command react-scripts are finishing and container restarts
# at least in container node:12.20.0-alpine3.9
# Possible bug and will be fixed in the future
ENV CI=true

#RUN npm install --only=prod --silent
RUN npm install --silent && npm cache clean --force;
COPY ./ ./
CMD ["npm", "run", "start"]