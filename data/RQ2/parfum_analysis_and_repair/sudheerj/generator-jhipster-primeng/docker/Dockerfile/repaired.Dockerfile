FROM ubuntu:20.04
RUN \

  groupadd jhipster && \
  useradd jhipster -s /bin/bash -m -g jhipster -G sudo && \
  echo 'jhipster:jhipster' |chpasswd && \
  mkdir /home/jhipster/app && \
  export DEBIAN_FRONTEND=noninteractive && \
  export TZ=Europe\Paris && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
  apt-get update && \
  # install utilities
  apt-get install --no-install-recommends -y \
    wget \
    sudo && \
  # install node.js
  wget https://nodejs.org/dist/v12.18.4/node-v12.18.4-linux-x64.tar.gz -O /tmp/node.tar.gz && \
  tar -C /usr/local --strip-components 1 -xzf /tmp/node.tar.gz && \
  # upgrade npm
  npm install -g npm && \
  # install yeoman
  npm install -g yo && \
  # cleanup
  apt-get clean && \
  rm -rf \
    /home/jhipster/.cache/ \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* && npm cache clean --force; && rm /tmp/node.tar.gz

# install jhipster
RUN npm install -g generator-jhipster@5.8.2 && npm cache clean --force;

RUN \

  npm install -g generator-jhipster-primeng && \
  # fix jhipster user permissions
  chown -R jhipster:jhipster \
    /home/jhipster \
    /usr/local/lib/node_modules && \
  # cleanup
  rm -rf \
    /home/jhipster/.cache/ \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* && npm cache clean --force;

# expose the working directory
USER jhipster
ENV PATH $PATH:/usr/bin
WORKDIR "/home/jhipster/app"
VOLUME ["/home/jhipster/app"]
CMD ["jhipster", "--blueprints", "primeng"]