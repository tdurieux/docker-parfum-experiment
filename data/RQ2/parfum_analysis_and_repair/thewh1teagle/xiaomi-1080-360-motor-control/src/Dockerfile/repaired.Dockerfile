# docker build -t name .

# docker run -v -it /path/on/host:/data container-image



FROM ubuntu:18.04


RUN apt-get update && apt-get install --no-install-recommends -y \
	bash-completion vim nano git curl wget unzip \
	g++-arm-linux-gnueabihf make file tmux \
	gcc software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt update
RUN apt install --no-install-recommends -y golang-go && rm -rf /var/lib/apt/lists/*;
RUN go get -u github.com/gorilla/mux

RUN mkdir /src

WORKDIR /src
