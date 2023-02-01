FROM node:16-alpine

# Set working directory
WORKDIR /bacstack

# Install dependencies
COPY package.json .
COPY yarn.lock .
RUN yarn --frozen-lockfile && yarn cache clean;

# Add node-bacstack
Add . .

# Run compliance tests
CMD yarn compliance
