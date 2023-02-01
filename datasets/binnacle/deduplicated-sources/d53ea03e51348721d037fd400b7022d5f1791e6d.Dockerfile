FROM python:3.7
LABEL MAINTAINER=dotkom@online.ntnu.no

# Install deps
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get remove -y curl && apt-get install -y --no-install-recommends \
    nodejs libjpeg-dev ghostscript && \
    npm install -g less && \
    npm install -g yarn && \
    pip install tox

# Clean up
RUN rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
