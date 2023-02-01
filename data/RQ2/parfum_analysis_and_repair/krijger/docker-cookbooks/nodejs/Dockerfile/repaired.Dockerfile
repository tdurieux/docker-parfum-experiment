FROM quintenk/supervisor

MAINTAINER Quinten Krijger "https://github.com/Krijger"

RUN apt-get -y --no-install-recommends install python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install python g++ make nodejs && rm -rf /var/lib/apt/lists/*;