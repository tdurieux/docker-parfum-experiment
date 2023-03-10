FROM python:3.9-slim

# Bash is installed for more convenient debugging.
RUN apt-get update && apt-get install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*
COPY . ./
RUN pip install --no-cache-dir . --use-feature=in-tree-build
