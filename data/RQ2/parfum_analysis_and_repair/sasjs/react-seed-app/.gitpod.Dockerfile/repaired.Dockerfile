FROM gitpod/workspace-full

RUN sudo apt-get update \
 && sudo apt-get install --no-install-recommends -y doxygen && rm -rf /var/lib/apt/lists/*;

