FROM node:14-alpine

# We need git and libsass

RUN apk add --no-cache \
    git \
    libsass

# Update NPM

RUN npm install -g npm@7 && npm cache clean --force;

# Ensure we have typescript and angular

RUN npm install -g typescript @angular/cli && npm cache clean --force;

# Gitlab CI has limited memory
ENV NODE_OPTIONS="--max_old_space_size=1024"