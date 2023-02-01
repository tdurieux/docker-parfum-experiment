FROM openjdk:11-jdk as build

# https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash - && apt install --no-install-recommends -y nodejs && node --version && rm -rf /var/lib/apt/lists/*;

WORKDIR /project
