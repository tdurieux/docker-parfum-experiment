FROM codercom/ubuntu-dev

RUN sudo apt-get update && sudo apt-get -y --no-install-recommends install fish && rm -rf /var/lib/apt/lists/*;
RUN sudo chsh user -s $(which fish)

LABEL share.fish="~/.config/fish:~/.config/fish"
