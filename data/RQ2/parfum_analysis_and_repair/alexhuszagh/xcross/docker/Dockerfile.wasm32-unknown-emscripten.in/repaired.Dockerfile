# Copy over the base data.
COPY --from=emscripten/emsdk:^EMSDK_VERSION^ /emsdk /emsdk
ENV PATH=/emsdk:/emsdk/upstream/emscripten:/emsdk/node/14.15.5_64bit/bin:"${PATH}"

# Install the required dependencies for wasm.
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install --assume-yes --no-install-recommends \
    curl \
    python3 \
    python3-pip \
    unzip \
    wget \
    zip && rm -rf /var/lib/apt/lists/*;

# Ensure the emsdk script is run on startup.
RUN echo ". /emsdk/emsdk_env.sh" >> /etc/bash.bashrc
