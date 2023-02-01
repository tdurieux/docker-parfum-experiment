####
# This Dockerfile is used in order to build a container that runs the NodeJS application.
#
# Build the image with:
#
# docker build -f src/main/docker/Dockerfile.build-native -t quarkus/ui-super-heroes .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/ui-super-heroes
#
## Stage 1 : Builds the application
FROM registry.access.redhat.com/ubi8/nodejs-16:1 as builder

# Add dependencies
COPY --chown=1001:1001 package*.json $HOME

# Install dependencies
RUN npm install && npm cache clean --force;

# Add application sources
COPY --chown=1001:1001 . $HOME

# Run build
RUN npm run build && \
    npm prune --production

## Stage 2 : Copies the application to the minimal image
FROM registry.access.redhat.com/ubi8/nodejs-16-minimal:1

# ENV variables
# API_BASE_URL: URL of service to connect to
# HTTP_PORT: The http port this service listens on
ENV HTTP_PORT=8080 \
    NODE_ENV=production

# Copy the application source and build artifacts from the builder image to this one
COPY --chown=1001:1001 --from=builder $HOME $HOME

# Expose the http port
EXPOSE $HTTP_PORT

# Run script uses standard ways to run the application
CMD npm start
