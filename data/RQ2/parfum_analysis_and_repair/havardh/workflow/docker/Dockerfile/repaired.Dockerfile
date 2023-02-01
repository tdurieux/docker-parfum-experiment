FROM circleci/node:14

# Install Xvfb
RUN sudo apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;

# Install workflow test dependencies
RUN sudo apt-get install --no-install-recommends -y i3 xterm scrot && rm -rf /var/lib/apt/lists/*;

# Set PS1
RUN sudo echo 'export PS1="\w # "' >> ~/.bash_profile

# Copy i3 config
COPY --chown=circleci:circleci src/.i3 /home/circleci/.i3
