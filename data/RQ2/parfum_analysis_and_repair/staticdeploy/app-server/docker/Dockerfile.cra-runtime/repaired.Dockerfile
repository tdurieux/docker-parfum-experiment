ARG DOCKER_TAG
FROM staticdeploy/app-server:$DOCKER_TAG

# Copy files from cra-runtime stage
ONBUILD COPY --from=0 /app/build /build
ONBUILD COPY --from=0 /app/app-server.config.js /app-server.config.js