FROM node:10.15.3-stretch

# AWS cli tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python \
    python-dev \
    python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli

# Copy and install frontend requirements
COPY . /opt/frontend
WORKDIR /opt/frontend
RUN yarn
