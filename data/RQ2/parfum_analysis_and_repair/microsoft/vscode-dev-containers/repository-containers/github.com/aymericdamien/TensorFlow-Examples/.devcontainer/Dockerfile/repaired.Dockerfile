FROM python:3

# install git iproute2
RUN apt-get update && apt-get -y --no-install-recommends install git iproute2 && rm -rf /var/lib/apt/lists/*;

# Install dev tools
RUN pip install --no-cache-dir pylint

# Install tensorflow
RUN pip install --no-cache-dir tensorflow

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
