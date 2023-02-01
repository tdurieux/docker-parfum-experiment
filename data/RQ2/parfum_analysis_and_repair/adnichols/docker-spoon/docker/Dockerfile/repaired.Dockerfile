FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y emacs24 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ack-grep && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xsel && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zsh && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y runit && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tree && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ncurses-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rake && rm -rf /var/lib/apt/lists/*;

RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

RUN apt-get -y --no-install-recommends install oracle-java7-installer && rm -rf /var/lib/apt/lists/*;

RUN easy_install httpie
RUN pip install --no-cache-dir https://github.com/Lokaltog/powerline/tarball/develop

# Tmux
RUN wget https://downloads.sourceforge.net/tmux/tmux-1.9a.tar.gz
RUN tar -zxf tmux-1.9a.tar.gz && rm tmux-1.9a.tar.gz
RUN cd tmux-1.9a && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install
RUN rm -r /tmux-1.9a*
RUN pip install --no-cache-dir --upgrade --user git+git://github.com/Lokaltog/powerline

RUN useradd -s /bin/zsh -m -d /home/pairing -g root pairing
RUN echo "pairing:pairing" | chpasswd
RUN echo "pairing        ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER pairing
ENV HOME /home/pairing
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/pairing/.oh-my-zsh
RUN chown -R pairing /home/pairing/.oh-my-zsh

RUN git clone https://github.com/adnichols/tmux-and-vim.git /home/pairing/.janus
RUN bash -l -c /home/pairing/.janus/setup/setup.sh
# Fixup powerline for this setup
RUN sed -i 's%/usr/local/lib/python2\.7/site-packages%/usr/local/lib/python2.7/dist-packages%' ~/.tmux.conf
ADD resources/zshrc.default /home/pairing/.zshrc
RUN mkdir /home/pairing/projects

USER root

# Runit setup
RUN mkdir -p /etc/service
ADD runit-ssh /etc/service/ssh
ADD runit /etc/runit

RUN mkdir -p /var/run/sshd

EXPOSE 22

CMD /usr/sbin/sshd -D -o UsePAM=no
