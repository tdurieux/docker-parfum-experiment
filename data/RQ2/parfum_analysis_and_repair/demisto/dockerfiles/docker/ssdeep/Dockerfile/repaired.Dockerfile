FROM demisto/python3-deb:3.9.6.24019

RUN apt-get update && apt-get install -y --no-install-recommends ssdeep \
    && rm -rf /var/lib/apt/lists/*
