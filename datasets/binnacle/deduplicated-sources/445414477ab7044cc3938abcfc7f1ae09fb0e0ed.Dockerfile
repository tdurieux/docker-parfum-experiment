FROM ocaml/opam2
RUN sudo apt update
RUN sudo apt install -y m4 perl libgmp-dev pkg-config zlib1g-dev python python-pip wget
RUN echo "deb http://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-stable/Debian_9.0/ ./" | sudo tee -a /etc/apt/sources.list
RUN wget https://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-stable/Debian_9.0/Release.key -O- | sudo apt-key add
RUN sudo apt install -y libzmq3-dev

RUN pip install jupyter
RUN opam remote add upstream https://github.com/ocaml/opam-repository.git && \
    opam update && opam upgrade
RUN opam -y depext lwt_ssl
RUN opam install -y lwt_ssl merlin utop user-setup github-unix jupyter

RUN sudo mkdir /usr/local/share/jupyter
RUN sudo chmod a+x /usr/local/share/jupyter
RUN python /home/opam/.local/bin/jupyter kernelspec install --name ocaml-jupyter "$(opam config var share)/jupyter" --user

COPY .ocamlinit /home/opam/.ocamlinit
WORKDIR /notebooks
ENV PATH $PATH:~/.local/bin
