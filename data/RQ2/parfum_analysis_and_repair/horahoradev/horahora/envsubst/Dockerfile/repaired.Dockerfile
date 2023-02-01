from ubuntu:focal

RUN apt-get update && \
    apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;