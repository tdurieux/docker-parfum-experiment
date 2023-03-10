FROM rust:1.32.0-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    python3 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3

# Using fork unti this is merged:
# https://github.com/getsentry/milksnake/pull/25
# Without this building inside docker fails.
RUN pip3 install --no-cache-dir https://github.com/nbigaouette/milksnake/archive/24-find_files-in-paths.zip
