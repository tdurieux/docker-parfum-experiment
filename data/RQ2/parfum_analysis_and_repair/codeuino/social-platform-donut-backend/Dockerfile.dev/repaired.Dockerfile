FROM node:14

ENV NODE_ENV="development"

# Copy package.json file into container
COPY package.json package.json
COPY package-lock.json package-lock.json

# Install node modules
RUN npm install && \
    npm install --only=dev && \
    npm cache clean --force --loglevel=error

# Volume to mount source code into container
VOLUME [ "/server" ]

# move to the source code directory
WORKDIR /server

# Start the server
CMD mv ../node_modules . && npm run dev