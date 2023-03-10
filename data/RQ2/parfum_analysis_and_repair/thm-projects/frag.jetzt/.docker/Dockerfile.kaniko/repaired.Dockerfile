# THIS DOCKERFILE IS SUPPOSED TO RUN ON THE KANIKO EXECUTOR
# ON SCM-ADMIN - ARTIFACT FROM PIPELINE NEEDED!

FROM nginx:stable-alpine

ARG BUILD_DIR=$BUILD_DIR

# Copy dist folder from artifact coordinator
COPY "${BUILD_DIR}" /var/www/frag.jetzt

# This hard-coded configuration can be overwritten with a volume at runtime