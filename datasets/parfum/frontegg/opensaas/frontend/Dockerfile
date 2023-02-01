FROM node:16.6.1

# Create Directory for the Container
WORKDIR /usr/src/app

ARG API_GW_URL
COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install

# Copy all other source code to work directory
COPY . /usr/src/app

RUN REACT_APP_API_GW_URL=$API_GW_URL npm run build

CMD ["node", "index"]

EXPOSE 8080
