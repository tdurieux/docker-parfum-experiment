# Set base image
ARG BASE_IMAGE=neuml/txtai-cpu
FROM $BASE_IMAGE

# Copy configuration
COPY config.yml .

# Run local API instance to cache models in container
RUN python -c "from txtai.api import API; API('config.yml', False)"

# Run workflow. Requires two command line arguments: name of workflow and input elements