FROM node:slim

RUN apt update && apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://get.volta.sh | bash

RUN export VOLTA_HOME=$HOME/.volta
RUN export PATH=$VOLTA_HOME/bin:$PATH
