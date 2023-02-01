FROM python:3.9-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y git gcc && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir notebook
RUN pip install --no-cache-dir git+https://github.com/openmined/PySyft@dev#subdirectory=packages/syft

WORKDIR /notebooks
