FROM python:3

# install git iproute2
RUN apt-get update && apt-get -y --no-install-recommends install git iproute2 && rm -rf /var/lib/apt/lists/*;

# Install node
RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install dev tools
RUN pip install --no-cache-dir closure
RUN npm install -g jshint && npm cache clean --force;

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*