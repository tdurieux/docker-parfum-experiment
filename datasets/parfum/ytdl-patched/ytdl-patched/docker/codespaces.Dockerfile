FROM mcr.microsoft.com/vscode/devcontainers/universal:linux

ENV PATH="$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

ARG NODE_VERSION="14"
RUN ( umask 0002 && . $HOME/.nvm/nvm.sh && nvm install ${NODE_VERSION} || true ) && \
    sed -i 's/# export LANG/export LANG/' ~/.bashrc && \
    pip3 install --user -U pytest nose flake8 pip && \
    sudo add-apt-repository -y ppa:git-core/ppa && \
    sudo apt update && \
    sudo apt upgrade -y && \
    sudo apt install -y --no-install-recommends \
        bzip2 ca-certificates curl file fonts-dejavu-core g++ \
        less libz-dev locales make netbase openssh-client patch \
        uuid-runtime tzdata ffmpeg rtmpdump shellcheck pandoc \
        aria2 transmission-cli axel httpie && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo mkdir -p /home/linuxbrew/.linuxbrew && \
    sudo chown -R codespace:codespace /home/linuxbrew/ && \
    git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/ && \
    brew doctor && \
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bash_profile && \
    HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1 brew tap homebrew/core nao20010128nao/my && \
    brew install nao20010128nao/my/advcomp docker-clean python@3.7 python@3.8 python@3.9 atomicparsley && \
    brew cleanup --prune 0 && \
    { git -C /home/linuxbrew/.linuxbrew config --unset gc.auto; true; } && \
    { git -C /home/linuxbrew/.linuxbrew config --unset homebrew.devcmdrun; true; } && \
    rm -rf ~/.cache && \
    chmod -R g+w,o-w /home/linuxbrew/.linuxbrew && \
    git config --global pull.rebase false && \
    wget https://github.com/yt-dlp/SponSkrub/releases/download/2021.03.15/sponskrub -O ~/.local/bin/sponskrub
