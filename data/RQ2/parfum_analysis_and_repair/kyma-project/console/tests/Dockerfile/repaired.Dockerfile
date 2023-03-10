FROM cypress/included:5.0.0

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;
LABEL source git@github.com:kyma-project/console.git
COPY . .
