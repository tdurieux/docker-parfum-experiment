FROM texlive/texlive:latest

# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
# https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions
ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Clean up
RUN apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog
