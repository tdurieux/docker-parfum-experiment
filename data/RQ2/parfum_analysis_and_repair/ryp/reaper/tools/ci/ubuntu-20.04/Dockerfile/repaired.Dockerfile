FROM ubuntu:20.04
RUN apt-get update && apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget unzip build-essential cmake gcc \
    libunwind-dev libx11-xcb-dev spirv-tools glslang-dev && rm -rf /var/lib/apt/lists/*;
