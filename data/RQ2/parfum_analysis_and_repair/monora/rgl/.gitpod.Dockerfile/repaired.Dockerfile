FROM gitpod/workspace-full

# Install graphviz
RUN sudo apt-get update --fix-missing \
    && sudo apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;

USER gitpod
