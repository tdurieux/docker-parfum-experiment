#
# Node.js Dockerfile
#
# https://github.com/dockerfile/nodejs
#

# Pull base image.
FROM dockerfile/python

# Install Node.js
RUN \
  cd /tmp && \
  wget https://nodejs.org/dist/v0.10.35/node-v0.10.35.tar.gz && \
  tar xvzf node-v0.10.35.tar.gz && \
  rm -f node-v0.10.35.tar.gz && \
  cd node-v* && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  printf '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc && npm cache clean --force;

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["bash"]

RUN npm install -g gulp bower node-sass && npm cache clean --force;
ADD package.json /app/package.json

WORKDIR /app
RUN npm install && npm cache clean --force;

WORKDIR /
ADD bower.json /app/bower.json
ADD .bowerrc /app/.bowerrc

WORKDIR /app
RUN bower install --allow-root

WORKDIR /
ADD client /app/client
ADD gulpfile.js /app/gulpfile.js

WORKDIR /app
RUN npm run build

WORKDIR /
ADD server /app/server
ADD config /app/config

# Define default command.
WORKDIR /app
CMD ["npm", "start"]
