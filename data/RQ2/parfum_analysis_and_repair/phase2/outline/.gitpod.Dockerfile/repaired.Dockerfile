FROM gitpod/workspace-node-lts

RUN sudo apt-get -qq update
RUN sudo apt-get -qq --no-install-recommends install -y rsync && rm -rf /var/lib/apt/lists/*;
