FROM continuumio/miniconda3
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    uuid-runtime && rm -rf /var/lib/apt/lists/*;
