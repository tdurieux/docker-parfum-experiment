# Need to add :latest, otherwise old versions (e.g. of node) are installed
FROM gitpod/workspace-full:latest

RUN curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
RUN sudo apt-get install -y --no-install-recommends git-lfs && rm -rf /var/lib/apt/lists/*;
RUN git lfs install
RUN echo "\nexport PATH=$(yarn global bin):\$PATH" >> /home/gitpod/.bashrc && yarn cache clean;
RUN yarn global add gitpod-env-per-project @babel/node @babel/core
RUN sudo apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN brew install gh

# Puppeteer dependencies
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y libgtk-3-0 libx11-xcb1 libnss3 libxss1 libasound2 libgbm1 libxshmfence1 && rm -rf /var/lib/apt/lists/*;
