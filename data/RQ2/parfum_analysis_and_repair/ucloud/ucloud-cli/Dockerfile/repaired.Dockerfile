FROM golang:latest

WORKDIR /root

RUN apt update \
        && apt install --no-install-recommends zsh vim -y \
        && wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
        && sh install.sh && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ucloud/ucloud-cli.git \
        && cd ucloud-cli && make install && cd ../ \
        && echo "autoload -U +X bashcompinit && bashcompinit \ncomplete -F $(which ucloud) ucloud" >> ~/.zshrc
