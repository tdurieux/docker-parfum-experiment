FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ make cmake git-core libevent-dev libev-dev && rm -rf /var/lib/apt/lists/*;