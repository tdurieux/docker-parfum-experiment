FROM rust:1.61.0-slim

# Install SemaphoreCI dependencies
# https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
RUN apt-get update && apt-get install --no-install-recommends -y curl git openssh-client && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]
