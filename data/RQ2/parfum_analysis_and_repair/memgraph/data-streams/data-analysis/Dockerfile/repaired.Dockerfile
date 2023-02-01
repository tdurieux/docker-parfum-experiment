FROM python:3.8

# Install CMake for gqlalchemy
RUN apt-get update && \
    apt-get --yes --no-install-recommends install cmake && \
    rm -rf /var/lib/apt/lists/*

# Install packages
COPY /data-analysis/requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

COPY /data-analysis/ /app/
WORKDIR /app