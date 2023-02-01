FROM debian:10
LABEL project="beatsaber-linux-goodies"
LABEL MAINTAINER Gareth Francis (gfrancis.dev@gmail.com)
RUN apt-get update && apt-get install --no-install-recommends -y cmake gcc g++ git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libz-dev libminizip-dev qtdeclarative5-dev qtbase5-dev && rm -rf /var/lib/apt/lists/*;

