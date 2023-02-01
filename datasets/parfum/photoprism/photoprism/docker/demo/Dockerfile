FROM photoprism/photoprism:preview as build

# Set environment variables
ENV TF_CPP_MIN_LOG_LEVEL=2 \
    PHOTOPRISM_STORAGE_PATH="/photoprism/storage" \
    PHOTOPRISM_DEBUG="false" \
    PHOTOPRISM_READONLY="false" \
    PHOTOPRISM_PUBLIC="true" \
    PHOTOPRISM_DEMO="true" \
    PHOTOPRISM_EXPERIMENTAL="true" \
    PHOTOPRISM_UPLOAD_NSFW="false" \
    PHOTOPRISM_DETECT_NSFW="false" \
    PHOTOPRISM_THUMB_FILTER="lanczos" \
    PHOTOPRISM_THUMB_UNCACHED="true" \
    PHOTOPRISM_THUMB_SIZE=4096 \
    PHOTOPRISM_THUMB_SIZE_UNCACHED=4096 \
    PHOTOPRISM_JPEG_SIZE=4096 \
    PHOTOPRISM_JPEG_QUALITY=85 \
    PHOTOPRISM_APP_NAME="Demo" \
    PHOTOPRISM_APP_ICON="favicon" \
    PHOTOPRISM_SITE_TITLE="PhotoPrism" \
    PHOTOPRISM_SITE_CAPTION="Demo" \
    PHOTOPRISM_SITE_DESCRIPTION="AI-Powered Photos App for the Decentralized Web"

# Copy assets
COPY /docker/demo/index.tmpl /opt/photoprism/assets/templates

# Download example photos
RUN wget -qO- https://dl.photoprism.app/qa/demo.tar.gz | tar xvz -C /photoprism/originals

# Import example photos
RUN photoprism restore -a
RUN photoprism index -a
RUN photoprism moments

# Start PhotoPrism server
CMD ["photoprism", "--public", "start"]
