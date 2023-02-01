FROM node:0.12

# Bundle app source
COPY . /src
WORKDIR /src

# Install app dependencies
RUN npm install && npm cache clean --force;

# Ready app for production build
RUN npm run build

# Run production build
EXPOSE 8080
EXPOSE 8443
CMD npm run start
