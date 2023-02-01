# Dockerfile.hvd-vision
FROM pytorchignite/hvd-base:latest

# Install opencv dependencies
RUN apt-get update && \
    apt-get -y install --no-install-recommends libglib2.0 \
                                               libsm6 \
                                               libxext6 \
                                               libxrender-dev \
                                               libgl1-mesa-glx && \
    rm -rf /var/lib/apt/lists/*

# Ignite vision dependencies