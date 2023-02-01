FROM node:17-buster

RUN apt update
RUN apt install --no-install-recommends -y \
    python3-pip \
    brotli \
    aspell && rm -rf /var/lib/apt/lists/*;

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN apt install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*;

ENV CONTAINERIZED=true

RUN pip3 install --no-cache-dir sultan
