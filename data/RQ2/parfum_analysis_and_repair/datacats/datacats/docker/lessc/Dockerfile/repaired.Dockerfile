FROM ubuntu:14.04

MAINTAINER boxkite

RUN locale-gen en_US.UTF-8 && \
echo 'LANG="en_US.UTF-8"' > /etc/default/locale

USER root

RUN apt-get -q -y update && apt-get -q --no-install-recommends -y install nodejs npm && rm -rf /var/lib/apt/lists/*; # Install Node.js and lessc

# -g is for global (on PATH)
RUN npm install -g less@1.7.5 && npm cache clean --force;

# lessc command line tool depends on nodejs being installed as 'node' on the PATH.
RUN ln -s /usr/bin/nodejs /usr/bin/node

CMD ["/project/compile_less.sh"]
