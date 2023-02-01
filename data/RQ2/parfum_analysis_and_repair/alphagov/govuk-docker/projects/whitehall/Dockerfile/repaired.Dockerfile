# Install packages for building ruby
FROM buildpack-deps

# Install chromium browser and its webdriver
RUN apt-get update -qq && apt-get install --no-install-recommends -y chromium chromium-driver && rm -rf /var/lib/apt/lists/*;

# Enable no-sandbox for chrome so that it can run as a root user
ENV GOVUK_TEST_CHROME_NO_SANDBOX 1

# Install node / yarn
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install --no-install-recommends -y yarn nodejs && rm -rf /var/lib/apt/lists/*;
RUN yarn config set cache-folder /root/.yarn/ && yarn cache clean;

# Install rbenv to manage ruby versions
RUN git clone https://github.com/rbenv/rbenv.git /rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /rbenv/plugins/ruby-build
RUN /rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/shims:/rbenv/bin:$PATH
ENV BUNDLE_SILENCE_ROOT_WARNING 1

# Install Whitehall specific dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y default-mysql-client ghostscript && rm -rf /var/lib/apt/lists/*;
