FROM node:17.9.0-slim

WORKDIR /app
# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# Install UI dependencies
COPY ui/package.json .
RUN npm install && npm cache clean --force;

# Copy over app
COPY ui/tsconfig.json .
COPY ui/public ./public
COPY ui/src ./src

# Build for production.
RUN npm run build --omit=dev

# Serve the UI from a port
RUN npm install -g serve && npm cache clean --force;
EXPOSE 3000
CMD ["serve", "-s", "build"]
