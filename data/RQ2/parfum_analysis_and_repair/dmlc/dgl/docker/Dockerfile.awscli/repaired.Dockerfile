# Using the Ubuntu image (our OS)
FROM ubuntu:latest
# Update package manager (apt-get)
# and install (with the yes flag `-y`)
# Python and Pip
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.8 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
        unzip \
        curl \
    && apt-get clean \
    && curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf \
        awscliv2.zip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pytest pytest-html requests
