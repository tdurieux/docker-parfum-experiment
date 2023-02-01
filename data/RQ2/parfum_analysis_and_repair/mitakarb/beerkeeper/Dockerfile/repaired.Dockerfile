FROM ruby:3.0.1

WORKDIR /app

# Using Node.js v14.x(LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

# Add packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    nodejs \
    vim && rm -rf /var/lib/apt/lists/*;

# Add yarnpkg for assets:precompile
RUN npm install -g yarn && npm cache clean --force;

# Add Chrome
RUN curl -f -sO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install --no-install-recommends -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*;

# Add chromedriver
RUN CHROME_DRIVER_VERSION=$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) \
    && curl -f -sO https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver
