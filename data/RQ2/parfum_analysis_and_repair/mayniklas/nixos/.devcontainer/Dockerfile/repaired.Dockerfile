FROM ubuntu:22.04

COPY ./site.yml /root/.ansible/site.yml

RUN apt update && \
    apt install --no-install-recommends -y ansible && \
    ansible-playbook /root/.ansible/site.yml && rm -rf /var/lib/apt/lists/*;

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -o pipefail && curl -f -L https://nixos.org/nix/install | bash && \
    locale-gen en_US.UTF-8

ENV USER=root
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN . "$HOME/.nix-profile/etc/profile.d/nix.sh" && \
    nix-env --install nixfmt

RUN mkdir /etc/nix && \
    touch /etc/nix/nix.conf && \
    echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
