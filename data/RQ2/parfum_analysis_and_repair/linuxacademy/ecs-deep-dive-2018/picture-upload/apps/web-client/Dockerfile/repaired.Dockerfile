FROM node:6

# Deps
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates git-core ssh && rm -rf /var/lib/apt/lists/*;

# Our source
RUN mkdir /app
WORKDIR /app
ADD . /app

# Install node deps for each app
RUN npm install --quiet && npm cache clean --force;