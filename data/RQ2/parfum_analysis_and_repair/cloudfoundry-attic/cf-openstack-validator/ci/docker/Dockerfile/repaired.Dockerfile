FROM ubuntu:16.04

RUN apt-get -y update && apt-get install --no-install-recommends -y locales && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

RUN apt-get update; apt-get -y upgrade; apt-get clean
RUN apt-get install --no-install-recommends -y sudo ssh curl wget make libssl-dev jq; rm -rf /var/lib/apt/lists/*; apt-get clean

# install newest git CLI
RUN apt-get install --no-install-recommends software-properties-common -y; rm -rf /var/lib/apt/lists/*; \
    add-apt-repository ppa:git-core/ppa -y; \
    apt-get update; \
    apt-get install --no-install-recommends apt-utils git -y


RUN mkdir /tmp/ruby-install && \
    cd /tmp && \
    curl -f https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.6.1 | tar -xz && \
    cd /tmp/ruby-install-0.6.1 && \
    make install && \
    rm -rf /tmp/ruby-install

RUN ruby-install --system ruby 2.4.6

RUN ["/bin/bash", "-l", "-c", "gem install bundler --no-ri --no-rdoc"]

RUN useradd -ms /bin/bash -G sudo validator-ci
RUN echo "%sudo ALL = NOPASSWD: ALL" >> /etc/sudoers.d/sudo_group

USER validator-ci
