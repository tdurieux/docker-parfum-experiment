FROM codercom/enterprise-base:ubuntu

# Run everything as root
USER root

# Packages required for multi-editor support
RUN DEBIAN_FRONTEND="noninteractive" apt-get update -y && \
    apt-get install --no-install-recommends -y \
    libxtst6 \
    libxrender1 \
    libfontconfig1 \
    libxi6 \
    libgtk-3-0 && rm -rf /var/lib/apt/lists/*;

# Set back to coder user
USER coder
