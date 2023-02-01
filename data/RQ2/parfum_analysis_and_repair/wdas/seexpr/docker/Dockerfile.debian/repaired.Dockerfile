FROM debian:testing
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y flex bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y llvm-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-dev libboost-python-dev && rm -rf /var/lib/apt/lists/*;
USER nobody
