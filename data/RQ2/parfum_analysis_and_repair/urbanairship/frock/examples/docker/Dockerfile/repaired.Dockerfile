FROM node:4

EXPOSE 8080

# Install app dependencies
COPY package.json /src/package.json
RUN cd /src; npm install && npm cache clean --force;

# Bundle app source
COPY . /src

# Run frock
ENV FROCK_UNSAFE_DISABLE_CONNECTION_FILTERING true
WORKDIR /src
CMD ["npm", "start"]
