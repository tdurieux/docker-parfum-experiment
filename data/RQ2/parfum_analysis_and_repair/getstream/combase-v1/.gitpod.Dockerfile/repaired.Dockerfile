FROM gitpod/workspace-mongodb

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

# Install Redis.
RUN sudo apt-get update \
  && sudo apt-get install --no-install-recommends -y \
  redis-server \
  && sudo rm -rf /var/lib/apt/lists/*