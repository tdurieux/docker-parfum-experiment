FROM node:16
WORKDIR /app

# Setup pnpm package manager
RUN npm install -g pnpm && npm cache clean --force;

# Setup proxy to API used in saleor-platform
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
COPY ./nginx/dev.conf /etc/nginx/conf.d/default.conf

COPY package.json ./
COPY pnpm-lock.yaml ./
RUN pnpm install
COPY . .
ARG API_URI
ENV API_URI ${API_URI:-http://localhost:8000/graphql/}

EXPOSE 3000
CMD pnpm dev -- --hostname 0.0.0.0
