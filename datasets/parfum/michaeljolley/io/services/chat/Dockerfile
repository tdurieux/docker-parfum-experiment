FROM io-shared as build

ARG BUILDVERSION=0.0.0

WORKDIR /app/chat

# Copy dependency files
COPY ./package.json ./package-lock.json ./

# Clean install depdenencies
RUN npm ci --silent

# ^^^^
# All layers above are cached, the below layers change more often
# vvvv

# Copy application code
COPY ./ .

# Build typescript files
RUN npm version $BUILDVERSION --allow-same-version;
RUN npm run build

# Put together the release image with the just build artifacts
FROM node:12.6.0-alpine

WORKDIR /app/chat

# Copy dependency files
COPY ./package.json ./package-lock.json ./

# Clean install production-only depdenencies
RUN npm ci --silent --only=production

WORKDIR /app/shared

# Copy shared dependencies
COPY --from=build /app/shared/package.json /app/shared/package-lock.json ./

# Clean install production-only dependencies for shared
RUN npm ci --silent --only=production

WORKDIR /app

# Copy built project and shared files
COPY --from=build /app/chat/dist ./chat/dist
COPY --from=build /app/shared/dist ./shared/dist

WORKDIR /app/chat

EXPOSE 80

CMD [ "node", "dist/index.js" ]
