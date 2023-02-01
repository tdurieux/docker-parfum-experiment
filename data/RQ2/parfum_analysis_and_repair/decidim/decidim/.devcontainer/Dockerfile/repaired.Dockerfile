FROM decidim/decidim:0.22.0-dev

RUN apt-get update && apt-get install --no-install-recommends -y \
  vim && rm -rf /var/lib/apt/lists/*;

ENV EDITOR=vim

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"
