FROM node:latest

RUN npm i -g npm && npm cache clean --force;
RUN npm i -g phantomjs-prebuilt && npm cache clean --force;

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ember-cli/ember-cli.git ~/ember-cli
RUN cd ~/ember-cli && npm i && npm cache clean --force;

ENTRYPOINT ["/bin/bash"]
