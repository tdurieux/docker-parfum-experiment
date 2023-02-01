FROM matthewpatell/universal-docker-server:4.0

# RUN apt-get update

# Install java
RUN apt-get install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;
