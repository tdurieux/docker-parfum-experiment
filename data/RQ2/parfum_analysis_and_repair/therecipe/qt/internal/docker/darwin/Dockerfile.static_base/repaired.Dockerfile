FROM ubuntu:16.04 as base

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install unzip && rm -rf /var/lib/apt/lists/*;

COPY env_darwin_amd64_513.zip $GOPATH/src/github.com/therecipe/env_darwin_amd64_513.zip
RUN cd $GOPATH/src/github.com/therecipe && unzip env_darwin_amd64_513.zip


FROM ubuntu:16.04
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work

COPY --from=base $GOPATH/src/github.com/therecipe/env_darwin_amd64_513 $GOPATH/src/github.com/therecipe/env_darwin_amd64_513