FROM ubuntu:18.10

RUN apt-get update -q \
   && apt-get install --no-install-recommends -qy \
      zsh \
      bash \
      neovim \
      vim \
      procps \
      make \
      git \
      socat \
      iproute2 \
      python \
      util-linux \
      findutils \
      sudo \
      ctags \
      locales \
      make \
      curl \
   && apt-get -y autoremove \
   && apt-get -y clean \
   && rm -rf /var/lib/apt/lists/* \
   && rm -rf /tmp/*

RUN curl -f -sL https://raw.githubusercontent.com/udhos/update-golang/master/update-golang.sh | bash \
      && ln -sf /usr/local/go/bin/go /usr/local/bin/go

RUN useradd -m joe
RUN chown -R joe:joe /home/joe
RUN echo 'joe ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/joe

USER joe
WORKDIR /home/joe
ENV HOME /home/joe

ENTRYPOINT ["/bin/zsh"]
