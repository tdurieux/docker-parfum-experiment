FROM node:18-alpine AS builder
ENV NODE_ENV production
# Add a work directory
WORKDIR /app
COPY taxonium_web_client ./taxonium_web_client
COPY taxonium_data_handling ./taxonium_data_handling
WORKDIR /app/taxonium_web_client

# Install dependencies for node-gyp from lzma-native
RUN apk add --no-cache python3 make g++
RUN yarn --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;

# Bundle static assets with nginx
FROM nginx:1.21.0-alpine as production
ENV NODE_ENV production
# Copy built assets from builder
COPY --from=builder /app/taxonium_web_client/build /usr/share/nginx/html
# Expose port
EXPOSE 80
# Start nginx
CMD ["nginx", "-g", "daemon off;"]
