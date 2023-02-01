FROM quay.io/continuouspipe/nodejs7:stable as build

# Install prerequisites build tools
RUN apt-get update \
  && apt-get install --no-install-recommends -y ruby ruby-dev build-essential git \
  && gem install --no-rdoc --no-ri sass -v 3.4.22 \
  && gem install --no-rdoc --no-ri compass \
  && npm install -g grunt-cli bower && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Build the application
WORKDIR /app

# Install node dependencies
ADD package.json /app/package.json
RUN npm install && npm cache clean --force;

# Install bower dependencies
ADD .bowerrc /app/.bowerrc
ADD bower.json /app/bower.json
RUN bower install --config.interactive=false --allow-root

# Build the code
COPY . /app

CMD ["grunt", "serve"]
