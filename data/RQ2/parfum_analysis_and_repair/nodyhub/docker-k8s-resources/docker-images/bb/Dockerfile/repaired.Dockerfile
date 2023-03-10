FROM ubuntu:18.04

ENV USERNAME hunter
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Create user `$USERNAME`
RUN apt update && \
    apt install --no-install-recommends -y zsh openssl sudo && \
    useradd -ms /usr/bin/zsh -p "$(openssl passwd -1 password)" $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/0-$USERNAME && \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/1-root-group && rm -rf /var/lib/apt/lists/*;

# install tools
WORKDIR /home/$USERNAME/git
COPY install-tools.sh install-tools.sh
RUN chmod 755 install-tools.sh && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/
USER $USERNAME
RUN ./install-tools.sh
COPY bin/ /home/$USERNAME/bin
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/

# yo! \m/
WORKDIR /home/$USERNAME
CMD zsh

