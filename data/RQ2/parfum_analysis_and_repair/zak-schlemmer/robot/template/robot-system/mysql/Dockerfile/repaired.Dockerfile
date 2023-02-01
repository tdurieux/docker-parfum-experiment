# image to use
FROM mysql:5.7

# add .my.cnf
COPY ./projects/custom/template/mysql/default.dot.my.cnf /root/.my.cnf

# apt-get what we need
RUN apt update && apt install --no-install-recommends -y \
  vim \
  nano \
  wget && rm -rf /var/lib/apt/lists/*;

# root .bashrc
RUN echo "PS1='\[\e[31m\]\u\[\e[m\]@\h:\w\$ '" >> /root/.bashrc
RUN echo "alias ll='ls -la'" >> /root/.bashrc
RUN echo "export TERM=xterm" >> /root/.bashrc
