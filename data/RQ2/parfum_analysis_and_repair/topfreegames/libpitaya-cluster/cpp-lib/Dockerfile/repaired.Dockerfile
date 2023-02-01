FROM conanio/clang11

RUN sudo apt-get update && sudo apt-get --assume-yes -y --no-install-recommends install golang-go ninja-build && rm -rf /var/lib/apt/lists/*;
