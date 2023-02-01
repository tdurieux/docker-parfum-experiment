FROM circleci/node:9.11.2

RUN sudo apt-get install -y --no-install-recommends mysql-client && rm -rf /var/lib/apt/lists/*;

RUN sudo npm i -g npm@6.1.0 && npm cache clean --force;

RUN sudo npm i -g forever && npm cache clean --force;

# Install electron dependencies
RUN sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y libgtk2.0-0 libgconf-2-4 \
  libasound2 libxtst6 libxss1 libnss3 xvfb && rm -rf /var/lib/apt/lists/*;
