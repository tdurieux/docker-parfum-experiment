FROM ruby:2.5.0

# Install Dependencies
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs npm && rm -rf /var/lib/apt/lists/*;

# Install Penthouse JS Dependencies
RUN apt-get install --no-install-recommends -y libpangocairo-1.0-0 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libnss3 libcups2 libxss1 libxrandr2 libgconf2-4 libasound2 libatk1.0-0 libgtk-3-0 && rm -rf /var/lib/apt/lists/*;

# Configure Node/NPM
RUN npm cache clean --force -f
RUN npm install -g n && npm cache clean --force;
RUN n 10.15.1
RUN ln -sf /usr/local/n/versions/node/10.15.1/bin/node /usr/bin/nodejs

ENV BUNDLE_PATH /gems

WORKDIR /app

COPY docker/ruby/startup.dev /usr/local/bin/startup
RUN chmod 755 /usr/local/bin/startup
CMD "/usr/local/bin/startup"