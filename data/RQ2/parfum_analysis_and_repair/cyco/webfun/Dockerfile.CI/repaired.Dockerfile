FROM ubuntu

# base
RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*;

# Install Node.js
RUN curl -f -sL https://deb.nodesource.com/setup_15.x | bash - \
	&& apt-get install --no-install-recommends -y nodejs build-essential && rm -rf /var/lib/apt/lists/*;

# Install Java for sonar scanner
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y default-jre && rm -rf /var/lib/apt/lists/*;

# Install Rust to build the documentation
RUN apt-get update -y && apt-get install --no-install-recommends -y cargo && rm -rf /var/lib/apt/lists/*;
RUN cargo install mdbook mdbook-open-on-gh
RUN apt-get update -y \
	&& apt-get install --no-install-recommends -y perl pkg-config libssl-dev \
	&& cargo install mdbook-linkcheck && rm -rf /var/lib/apt/lists/*;

# Install yarn for package management
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& apt-get update -y && apt-get install -y --no-install-recommends yarn \
	&& rm -rf /etc/apt/sources.list.d/yarn.list && rm -rf /var/lib/apt/lists/*;

# Install Chromium for test execution
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y chromium-browser && rm -rf /var/lib/apt/lists/*;

# Perform cleanup
RUN apt-get purge --auto-remove -y curl gnupg \
	&& rm -rf /var/lib/apt/lists/*

# Setup package cache for yarn and cache current dependencies
ENV YARN_CACHE_FOLDER=/cache/yarn
ADD yarn.lock yarn.lock
ADD package.json package.json

RUN yarn install --frozen-lockfile --non-interactive && rm -rf node_modules package.json yarn.lock && yarn cache clean;
