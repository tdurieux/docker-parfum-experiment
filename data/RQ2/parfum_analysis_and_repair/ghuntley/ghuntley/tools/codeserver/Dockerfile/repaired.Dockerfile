FROM codercom/code-server:latest

EXPOSE 8443

VOLUME [ "${PWD}:/home/coder/code" ]

USER root

RUN apt-get update

# Install direnv
RUN apt-get -y --no-install-recommends install direnv && rm -rf /var/lib/apt/lists/*;

# Install Nix
RUN addgroup --system nixbld \
  && usermod -a -G nixbld coder \
  && mkdir -m 0755 /nix && chown coder /nix \
  && mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf

# Install Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
  && sudo sh get-docker.sh \
  && usermod -aG docker coder

RUN apt-get update \
  && apt-get install --no-install-recommends -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils \
  && usermod -aG kvm coder \
  && usermod -aG kvm root \
  && usermod -aG libvirt coder \
  && usermod -aG libvirt root && rm -rf /var/lib/apt/lists/*;

# Install Nix
CMD /bin/bash -l
USER coder
ENV USER coder
WORKDIR /home/coder

RUN touch .bash_profile && \
  curl -f https://nixos.org/nix/install | sh

RUN mkdir -p /home/coder/.config/nixpkgs && echo '{ allowUnfree = true; }' >> /home/coder/.config/nixpkgs/config.nix

RUN echo '. /home/gitpod/.nix-profile/etc/profile.d/nix.sh' >> /home/coder/.bashrc
RUN echo 'eval "$(direnv hook bash)"' >> /home/coder/.bashrc
RUN echo 'eval `ssh-agent`' >> /home/coder/.bashrc

# Install visual studio code niceities
RUN sudo apt-get install -y --no-install-recommends silversearcher-ag && rm -rf /var/lib/apt/lists/*;

# Reset the font cache
#USER coder
#RUN fc-cache -f -v
