FROM ubuntu:latest

ENV SHELL bash
ENV DEBIAN_FRONTEND noninteractive

RUN useradd test
RUN usermod -aG sudo test
RUN mkdir /home/test
RUN chown test:test -R /home/test

RUN apt-get update && apt-get install --no-install-recommends -y \
  bat \
  ack-grep \
  fzf \
  vim \
  curl \
  git \
  lsof \
  bash \
  stow \
  tmux \
  python3 \
  python3-pip \
  nodejs && rm -rf /var/lib/apt/lists/*;

# Install latest starship
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- -y

USER test

WORKDIR /home/test

RUN mkdir /home/test/dotfiles

COPY --chown=test:test bash dotfiles/bash
COPY --chown=test:test git dotfiles/git
COPY --chown=test:test local dotfiles/local
COPY --chown=test:test postgres dotfiles/postgres
COPY --chown=test:test rubygems dotfiles/rubygems
COPY --chown=test:test tmux dotfiles/tmux
COPY --chown=test:test vim dotfiles/vim
COPY --chown=test:test X dotfiles/X
COPY --chown=test:test install dotfiles
COPY --chown=test:test backup dotfiles

CMD ["bash"]
