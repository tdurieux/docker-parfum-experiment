# image to use
FROM debian:jessie

# apt-get what we need
RUN apt update && apt install --no-install-recommends -y \
  telnet \
  vim \
  nano \
  net-tools \
  wget \
  memcached && rm -rf /var/lib/apt/lists/*;

# root .bashrc
RUN echo "PS1='\[\e[31m\]\u\[\e[m\]@\h:\w\$ '" >> /root/.bashrc
RUN echo "alias ll='ls -la'" >> /root/.bashrc
RUN echo "export TERM=xterm" >> /root/.bashrc
