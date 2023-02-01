FROM gitpod/workspace-full

ENV DISPLAY :99.0
# Install custom tools, runtime, etc.
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y libglu1-mesa-dev freeglut3-dev mesa-common-dev && rm -rf /var/lib/apt/lists/*;
