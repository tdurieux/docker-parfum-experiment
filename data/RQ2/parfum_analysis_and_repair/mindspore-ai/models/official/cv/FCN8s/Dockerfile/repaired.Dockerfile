ARG FROM_IMAGE_NAME
FROM ${FROM_IMAGE_NAME}

RUN apt-get install --no-install-recommends -y libnuma-dev && rm -rf /var/lib/apt/lists/*;
