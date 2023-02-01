FROM ubuntu:16.04
MAINTAINER Logan Hanks <logan@euphoria.io>

ENV PATH /root/go/src/euphoria.io/heim/client/node_modules/.bin:/usr/lib/go-1.10/bin:$PATH

# install bazel and upgrade OS
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install --no-install-recommends -y openjdk-8-jdk curl && rm -rf /var/lib/apt/lists/*;
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/bazel.list
RUN curl -f https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN apt-get update
RUN apt-get install --no-install-recommends -y bazel && rm -rf /var/lib/apt/lists/*;

# install node and npm
RUN apt-get install --no-install-recommends -y nodejs nodejs-legacy npm && rm -rf /var/lib/apt/lists/*;

# install golang
RUN apt-get install --no-install-recommends -y git golang-1.10 && rm -rf /var/lib/apt/lists/*;

# install phantomjs dependency
RUN apt-get install --no-install-recommends -y libfontconfig && rm -rf /var/lib/apt/lists/*;

# copy source code to /srv/heim/client/src
ADD ./ /root/go/src/euphoria.io/heim/

# install client dependencies
WORKDIR /root/go/src/euphoria.io/heim/client
RUN npm install && npm cache clean --force;

# build client
ENV NODE_ENV production
RUN gulp build

# build server
RUN bazel build --workspace_status_command=./bzl/status.sh //heimctl
