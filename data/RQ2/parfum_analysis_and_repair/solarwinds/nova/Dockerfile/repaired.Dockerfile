FROM node:lts-slim
ENV NODE_OPTIONS --max-old-space-size=8192

# Installing tools
RUN apt-get update && \
    apt-get -y --no-install-recommends install git curl wget nano vim procps sudo xvfb && rm -rf /var/lib/apt/lists/*;

# Install chrome
RUN curl -f -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y google-chrome-stable && \
    ln -s /usr/bin/google-chrome /usr/bin/chrome && \
    rm /etc/apt/sources.list.d/google.list && rm -rf /var/lib/apt/lists/*;

EXPOSE 4200 49153
