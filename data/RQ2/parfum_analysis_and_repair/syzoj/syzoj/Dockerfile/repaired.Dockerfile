FROM node:16-bullseye

# Install OS dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y p7zip-full clang-format && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

# Install NPM dependencies
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile --ignore-scripts && yarn cache clean;

# Copy code and run post-install scripts
COPY . .
RUN yarn --frozen-lockfile && yarn cache clean;

ENV NODE_ENV=production \
    SYZOJ_WEB_LISTEN_HOSTNAME=0.0.0.0 \
    SYZOJ_WEB_LISTEN_PORT=80

VOLUME ["/app/config", "/app/uploads", "/app/sessions"]

CMD ["app.js", "-c", "config/web.json"]
