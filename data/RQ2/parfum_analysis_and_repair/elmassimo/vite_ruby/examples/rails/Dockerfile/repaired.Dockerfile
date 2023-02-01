FROM ruby:3.0 AS builder

# Install nodejs in the ruby image
RUN curl -f -sL https://deb.nodesource.com/setup_15.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

# Gems and packages will be cached in a separate image using a mounted volume.
ENV BUNDLE_PATH /bundler_cache
ENV YARN_CACHE_FOLDER /yarn_cache

# Set working directory inside the image home.
ENV APP_PATH /app
WORKDIR $APP_PATH
ADD . $APP_PATH
