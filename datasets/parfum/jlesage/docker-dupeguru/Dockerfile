#
# dupeguru Dockerfile
#
# https://github.com/jlesage/docker-dupeguru
#

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.15-v3.5.8

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=unknown

# Define software versions.
ARG DUPEGURU_VERSION=4.2.1

# Define software download URLs.
ARG DUPEGURU_URL=https://github.com/arsenetar/dupeguru/archive/${DUPEGURU_VERSION}.tar.gz

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN add-pkg \
        python3 \
        py3-qt5 \
        mesa-dri-swrast \
        dbus

# Install dupeGuru.
RUN \
    # Install packages needed by the build.
    add-pkg --virtual build-dependencies \
        build-base \
        python3-dev \
        py3-pip \
        gettext \
        curl \
        && \
    # Download the dupeGuru package.
    echo "Downloading dupeGuru..." && \
    mkdir dupeguru && \
    curl -L -# ${DUPEGURU_URL} | tar xz --strip 1 -C dupeguru && \
    # Install Python dependencies.
    pip3 install -r dupeguru/requirements.txt && \
    # Compile dupeGuru.
    echo "Compiling dupeGuru..." && \
    cd dupeguru && \
    make PREFIX=/usr/ NO_VENV=1 install && \
    cd .. && \
    rm -r /usr/share/applications && \
    # Enable direct file deletion by default.
    #sed-patch 's/self.direct = False/self.direct = True/' /usr/share/dupeguru/core/gui/deletion_options.py && \
    # Cleanup.
    del-pkg build-dependencies && \
    rm -rf /tmp/* /tmp/.[!.]*

# Adjust openbox config.
RUN \
    # Maximize only the main/initial window.
    sed-patch 's/<application type="normal">/<application type="normal" title="dupeGuru">/' \
        /etc/xdg/openbox/rc.xml && \
    # Make sure the main window is always in the background.
    sed-patch '/<application type="normal" title="dupeGuru">/a \    <layer>below</layer>' \
        /etc/xdg/openbox/rc.xml && \
    # Make sure dialog windows are always above other ones.
    sed-patch '/<\/applications>/i \  <application type="dialog">\n    <layer>above<\/layer>\n  <\/application>' \
        /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/dupeguru-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /

# Set environment variables.
ENV APP_NAME="dupeGuru" \
    TRASH_DIR="/trash"

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]
VOLUME ["/trash"]

# Metadata.
LABEL \
      org.label-schema.name="dupeguru" \
      org.label-schema.description="Docker container for dupeGuru" \
      org.label-schema.version="$DOCKER_IMAGE_VERSION" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-dupeguru" \
      org.label-schema.schema-version="1.0"
