FROM ccdlstaging/dr_affymetrix:latest

USER root

# Remove the version of common already installed.
RUN rm -r common/
RUN pip3 uninstall -y data_refinery_common

# Reinstall common.
COPY common/dist/data-refinery-common-* common/
# Get the latest version from the dist directory.
RUN pip3 install --no-cache-dir common/$(ls common -1 | sort --version-sort | tail -1)

ARG SYSTEM_VERSION

ENV SYSTEM_VERSION $SYSTEM_VERSION

USER user

COPY config/ config/
COPY workers/ .

ENTRYPOINT []
