FROM gcr.io/cloud-builders/curl
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;