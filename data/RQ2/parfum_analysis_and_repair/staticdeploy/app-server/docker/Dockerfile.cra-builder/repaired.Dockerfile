FROM node:lts

ONBUILD WORKDIR /app

# Copy source files
ONBUILD COPY . .

# Create an empty app-server.config.js file if it doesn't exist
ONBUILD RUN if [ ! -f app-server.config.js ]; then echo "module.exports={};" > app-server.config.js; fi

# Set PUBLIC_URL so that app paths are relative (app-server will then figure out
# what to serve)
ONBUILD ENV PUBLIC_URL .

# Install dependencies (with yarn if there is a yarn.lock)
 \
RUN if [ -f yarn.lock ]; then \
 yarn install; yarn cache clean; else npm install; npm cache clean --force; fiONBUILD

# Build the app
ONBUILD RUN yarn build
