FROM ubuntu:18.04

RUN apt update

# install python 3.8
RUN apt-get install --no-install-recommends python3.8 -y && rm -rf /var/lib/apt/lists/*;

# install python 2.7
RUN apt-get install --no-install-recommends python2.7 -y && rm -rf /var/lib/apt/lists/*;

# install perl
RUN apt-get install --no-install-recommends perl -y && rm -rf /var/lib/apt/lists/*;

# install g++ and gcc
RUN apt install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;

