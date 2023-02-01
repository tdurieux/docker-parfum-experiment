FROM dockerfile/nodejs
# https://registry.hub.docker.com/u/dockerfile/nodejs/

RUN apt-get update && apt-get -y --no-install-recommends install \
 git \
 imagemagick \
 libmagick++-dev \
 node-gyp \
 emacs && rm -rf /var/lib/apt/lists/*;

RUN cd /data && git clone https://github.com/mash/node-imagemagick-native.git
WORKDIR /data/node-imagemagick-native

RUN npm install --unsafe-perm && npm cache clean --force;

# to test pull requests
RUN git config --local --add remote.origin.fetch "+refs/pull/*/head:refs/remotes/pr/*" && \
    git fetch

CMD ["bash"]
