FROM phusion/baseimage:0.9.18

MAINTAINER Bo-Yi Wu <appleboy.tw@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root


RUN apt-get update && apt-get install --no-install-recommends -y git rsync curl wget && rm -rf /var/lib/apt/lists/*;
# install tmux
RUN apt-get -y --no-install-recommends install libevent-dev libncurses-dev make && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz -O tmux-2.2.tar.gz
RUN tar xvzf tmux-2.2.tar.gz && cd tmux-2.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install -m prefix=/usr && rm tmux-2.2.tar.gz
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales
RUN git clone https://github.com/appleboy/dotfiles.git
RUN chmod 755 dotfiles/bootstrap.sh
RUN ./dotfiles/bootstrap.sh -f

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD /bin/bash
