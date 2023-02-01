FROM python:3.8-buster


# Volumes
VOLUME /config
VOLUME /models
VOLUME /data

# ZMQ
EXPOSE 5454
# Audio
EXPOSE 5557

# Dir
WORKDIR /tmp

# Copy setup
COPY README.md ./
COPY setup.py ./
COPY sbin/ ./sbin/
COPY scarecrow_server/ ./scarecrow_server/
COPY scarecrow_client/ ./scarecrow_client/
COPY scarecrow_core/ ./scarecrow_core/
COPY models/ ./models/

# Install protoc
RUN apt-get update && apt-get install --no-install-recommends -y protobuf-compiler alsa-utils && rm -rf /var/lib/apt/lists/*;

# Update pip
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir wheel

# Run setup
RUN pip install --no-cache-dir . --upgrade

# Install the models manually to ensure protobuf works
RUN bash ./sbin/install_tensorflow_models.sh

# Start
ENTRYPOINT ["/usr/local/bin/python3"]