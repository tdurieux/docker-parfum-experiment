# FROM $GO_IMAGE
FROM rust:1.58.1
RUN apt-get update && apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

# Copy SDK code into the container
RUN mkdir -p $HOME/algonaut
COPY . $HOME/algonaut
WORKDIR $HOME/algonaut

# Run integration tests
# CMD ["/bin/bash", "-c", "make unit && make integration"]
CMD ["/bin/bash", "-c", "make integration"]
