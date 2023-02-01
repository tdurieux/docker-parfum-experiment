FROM raspbian/stretch

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    apache2 && rm -rf /var/lib/apt/lists/*;
