FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y git bison build-essential autoconf ruby curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zlib1g-dev clang ruby-dev shellcheck && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN gem install bundler
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

ADD ./ /root/rubyfmt.git
