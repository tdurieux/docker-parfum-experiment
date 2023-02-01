### Dockerfile to build the UP42 superresolution block.

# Use up42 python 3.7 tensorflow 2 base image
FROM up42/up42-tf2-py38

# The manifest file contains metadata for correctly building and
# tagging the Docker image. This is a build time argument.
ARG manifest
LABEL "up42_manifest"=$manifest

# Working directory setup.
WORKDIR /block
COPY requirements.txt /block

# Install the Python requirements.
RUN pip install --no-cache-dir -r requirements.txt --use-feature=2020-resolver

# Copy the code into the container.
COPY src /block/src
COPY weights /block/weights

# Invoke run.py.
CMD ["python", "/block/src/run.py"]
