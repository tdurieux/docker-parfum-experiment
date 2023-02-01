# This a dev image for testing your plugin when installed into the Baserow web-frontend image
FROM baserow/web-frontend:1.10.2 as base
FROM baserow/web-frontend:1.10.2

USER root

ARG PLUGIN_BUILD_UID
ENV PLUGIN_BUILD_UID=${PLUGIN_BUILD_UID:-9999}
ARG PLUGIN_BUILD_GID
ENV PLUGIN_BUILD_GID=${PLUGIN_BUILD_GID:-9999}

# If we aren't building as the same user that owns all the files in the base
# image/installed plugins we need to chown everything first.