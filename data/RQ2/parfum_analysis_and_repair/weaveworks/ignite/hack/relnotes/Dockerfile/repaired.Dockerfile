FROM node

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN npm install gulp -g && npm cache clean --force;
RUN git clone https://github.com/github-tools/github-release-notes
WORKDIR /github-release-notes
RUN npm install && npm cache clean --force;
RUN gulp build && ln -s /github-release-notes/bin/gren.js /usr/local/bin/gren
