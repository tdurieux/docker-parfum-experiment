FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
 && curl -f -sL https://deb.nodesource.com/setup_7.x | bash - \
 && apt-get update \
 && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;