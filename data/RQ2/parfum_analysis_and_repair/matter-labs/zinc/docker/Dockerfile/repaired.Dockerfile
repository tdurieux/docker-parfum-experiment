FROM rust:1.48 as zinc-builder
COPY . zinc-dev/

WORKDIR /zinc-dev/

RUN apt-get update --yes && apt-get install --no-install-recommends --yes \
    'apt-utils' \
    'dialog' \
    'dos2unix' \
    'zip' && rm -rf /var/lib/apt/lists/*; # Auxiliary tools






# Fixing Windows '\r\n' line endings
RUN dos2unix 'docker/build.sh'

# Main build script, expects the Zinc version
RUN /bin/bash 'docker/build.sh' '0.2.3'
