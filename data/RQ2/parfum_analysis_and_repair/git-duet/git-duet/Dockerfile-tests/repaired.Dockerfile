FROM golang:latest

RUN apt update && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && apt install --no-install-recommends -y git bats software-properties-common && add-apt-repository ppa:git-core/ppa -y && apt update && apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
ADD . /go/src/github.com/git-duet/git-duet
WORKDIR /go/src/github.com/git-duet/git-duet
RUN ./scripts/install

# vim:ft=dockerfile
