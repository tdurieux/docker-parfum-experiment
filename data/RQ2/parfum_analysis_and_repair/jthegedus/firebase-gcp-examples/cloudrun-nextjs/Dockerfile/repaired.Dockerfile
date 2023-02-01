# COPY Files
FROM node:12-alpine AS build-env
WORKDIR /app
COPY . .
RUN npm install && npm run build && npm cache clean --force;

# Copy app and deps
FROM node:12-alpine
WORKDIR /app
COPY --from=build-env /app .
RUN rm -rf node_modules && npm install --only=production && npm cache clean --force;

# Run Next.js
CMD ["npm", "run", "start"]
