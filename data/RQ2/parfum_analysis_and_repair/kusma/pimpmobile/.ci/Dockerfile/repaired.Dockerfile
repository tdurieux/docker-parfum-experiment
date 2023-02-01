FROM devkitpro/devkitarm

RUN apt-get update && \
    apt install --no-install-recommends -y gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
