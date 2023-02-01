ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir scaden

# Install tensorflow-gpu if GPU container
ARG GPU
RUN if [ "$GPU" = "GPU" ]; then \
    pip3 install --no-cache-dir tensorflow-gpu; \
    fi