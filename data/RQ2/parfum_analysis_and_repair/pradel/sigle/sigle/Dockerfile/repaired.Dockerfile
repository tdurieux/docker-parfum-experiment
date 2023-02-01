# Stage 1: Building the code
FROM node:16 AS builder

RUN corepack enable && corepack prepare pnpm@7.1.5 --activate

WORKDIR /app

COPY pnpm-lock.yaml ./

RUN pnpm fetch

# Copy the rest of the code
COPY . .

RUN pnpm install -r --offline

# Build the next.js application
RUN pnpm --filter=@sigle/app run build
# Install only the production dependencies to reduce the image size
RUN pnpm install --prod --filter=@sigle/app

# Stage 2: And then copy over node_modules, etc from that stage to the smaller base image