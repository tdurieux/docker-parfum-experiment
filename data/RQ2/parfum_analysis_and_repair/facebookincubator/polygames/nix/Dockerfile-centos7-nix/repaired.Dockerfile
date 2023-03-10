# docker build -t polygames-centos7-nix -f Dockerfile-centos7-nix .
# docker run --rm -it polygames-centos7-nix
# nix-shell nix/shell-cpu.nix --run "python -m pypolygames train --game_name Hex11 --device=cpu"

FROM centos:centos7
RUN yum update -y
RUN yum install -y git curl sudo xz-utils cacert && rm -rf /var/cache/yum
RUN useradd -ms /bin/bash -G wheel myuser
RUN echo "myuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER myuser
ENV USER="myuser"
ENV HOME="/home/myuser"

RUN curl -f https://nixos.org/releases/nix/latest/install | sh
RUN echo "source $HOME/.nix-profile/etc/profile.d/nix.sh" >> $HOME/.bashrc
RUN source $HOME/.bashrc
ENV PATH="$HOME/.nix-profile/bin/:$PATH#"
ENV NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"

RUN nix-env -iA nixpkgs.cachix
RUN cachix use polygames

WORKDIR $HOME
RUN git clone https://github.com/juliendehos/Polygames.git --branch=nix

RUN mkdir $HOME/Polygames/build
WORKDIR $HOME/Polygames/build
RUN nix-shell ../nix/shell-cpu.nix --run "cmake -DPYTORCH12=ON .. ; make -j4"
WORKDIR $HOME/Polygames/

