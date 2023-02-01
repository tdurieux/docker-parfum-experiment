FROM codercom/enterprise-base:ubuntu

USER root

# Install code-server v3.12.0 for modern extensions
ARG VERSION=3.12.0
ARG ARCH=amd64
RUN curl -f -L "https://github.com/coder/code-server/releases/download/v$VERSION/code-server_${VERSION}_$ARCH.deb" -o \
    "/tmp/code-server_${VERSION}_$ARCH.deb"
RUN dpkg -i "/tmp/code-server_${VERSION}_$ARCH.deb"

# Install Node v14 (should match "engine" in ../package.json)
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --batch --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install --no-install-recommends -y gh && rm -rf /var/lib/apt/lists/*;

# Copy our apps and extensions
COPY ./apps /coder/apps
COPY ./extensions /coder/extensions

# Copy configure script
COPY ./configure /coder/configure

USER coder
