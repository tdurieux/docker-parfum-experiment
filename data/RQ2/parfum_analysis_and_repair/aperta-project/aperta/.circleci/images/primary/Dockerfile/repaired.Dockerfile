FROM circleci/ruby:2.4.10
USER circleci

ENV NVM_DIR /home/circleci/.nvm
ENV NODE_VERSION 6.11.1

RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y openjdk-11-jre libgtk-3-0 libdbus-glib-1-2 ghostscript && rm -rf /var/lib/apt/lists/*;

# Install nvm with node and npm
RUN mkdir -p $NVM_DIR
RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION
