FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ make && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && sudo apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;