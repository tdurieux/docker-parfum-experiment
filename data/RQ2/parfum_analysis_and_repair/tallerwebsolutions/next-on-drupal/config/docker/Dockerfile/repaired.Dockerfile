FROM node:8.10.0

RUN apt-get update && apt-get install --no-install-recommends \
  nano \
  git \
  tig \
  python \
  ca-certificates \
  groff \
  less \
  curl \
  gzip \
  htop \
  sudo \
  vim \
  wget \
  unzip -y && rm -rf /var/lib/apt/lists/*;

RUN echo "%node ALL=(ALL) ALL" >> /etc/sudoers

# Improve terminal ux with custom bashrc config
COPY ./.bashrc /home/node/.bashrc
RUN chown node:node /home/node/.bashrc

USER node
WORKDIR /home/node/app

ENV NODE_ENV development

ENTRYPOINT ["/bin/bash"]
