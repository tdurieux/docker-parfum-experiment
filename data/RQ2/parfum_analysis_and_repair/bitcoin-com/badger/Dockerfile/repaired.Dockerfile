FROM node:10.20.1-stretch

# Install build dependencies
RUN apt-get update && apt-get install --no-install-recommends -y build-essential python curl && rm -rf /var/lib/apt/lists/*;

# Setup app directory
RUN mkdir -p /app/
WORKDIR /app/

# Copy source to app directory
COPY ./ /app/

# Install dependencies
RUN npm install >> npm_log 2>> npm_err || true && npm cache clean --force;
RUN cat npm_log && cat npm_err

# Build browser distribution packages
RUN npm run dist

CMD echo "Build complete"
