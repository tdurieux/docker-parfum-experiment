FROM codercom/enterprise-base:ubuntu

# Run everything as root
USER root

# Install whichever Node version is LTS
RUN curl -f -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN DEBIAN_FRONTEND="noninteractive" apt-get update -y && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# Set back to coder user
USER coder
