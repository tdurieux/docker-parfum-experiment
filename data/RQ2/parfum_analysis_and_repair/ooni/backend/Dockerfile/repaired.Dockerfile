# Build: run ooni-sysadmin.git/scripts/docker-build from this directory

FROM python:2.7.15-slim
ENV PYTHONUNBUFFERED 1

ENV PYTHONPATH /app/

# Setup the locales in the Dockerfile
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends locales -y \
    && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

RUN set -x \
    && apt-get install --no-install-recommends gcc g++ make python-dev -y && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN set -x \
    && pip install --no-cache-dir -U pip setuptools \
    && pip install --no-cache-dir -r /tmp/requirements.txt

# Install tor

RUN set -x \
    && apt-get install --no-install-recommends tor -y && rm -rf /var/lib/apt/lists/*;

# Copy the directory into the container
COPY . /app/

# Set our work directory to our app directory
WORKDIR /app/
