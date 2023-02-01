FROM fedora:29

RUN dnf -y -d1 upgrade

RUN dnf -y -d1 install \
      zsh \
      neovim \
      vim \
      procps-ng \
      make \
      git \
      socat \
      iproute \
      python \
      util-linux \
      dnf-plugins-core \
      findutils \
      sudo \
      ctags

# install docker edge releases
# RUN dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo \
#     && dnf config-manager --set-enabled docker-ce-edge \
#     && dnf install -y -d1 docker-ce
# TODO: ugly workaround until regular releaeses are available for fedora29: https://github.com/docker/for-linux/issues/430
#RUN curl -fsSL get.docker.com | CHANNEL=nightly sh

# install latest golang rpm's from go-repo.io:
RUN rpm --import https://mirror.go-repo.io/fedora/RPM-GPG-KEY-GO-REPO \
    && curl -f -s https://mirror.go-repo.io/fedora/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo \
    && dnf -y install golang

RUN useradd -m joe
RUN chown -R joe:joe /home/joe
RUN echo 'joe ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/joe

USER joe
WORKDIR /home/joe
ENV HOME /home/joe

ENTRYPOINT ["/bin/zsh"]
