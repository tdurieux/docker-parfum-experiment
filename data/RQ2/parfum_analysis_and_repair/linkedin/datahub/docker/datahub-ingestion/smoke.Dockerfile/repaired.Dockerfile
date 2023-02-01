FROM acryldata/datahub-ingestion-base as base

RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo \
    python3-dev \
    libgtk2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xauth \
    xvfb && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;