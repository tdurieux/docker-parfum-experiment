FROM buildkite/puppeteer:5.2.1

WORKDIR /src

COPY package*.json /src/

# Install Node packages
RUN npm install --loglevel=error && npm cache clean --force;

# Copy the rest
COPY . .

# Test Frontend
RUN npm run test:coverage

# Build Frontend
RUN npm run build

