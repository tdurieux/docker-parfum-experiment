FROM ubuntu:xenial

RUN apt-get update


# Use UTF-8
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

# For debugging
RUN apt-get install --no-install-recommends -y vim-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y less && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gdb-multiarch && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/pwndbg/pwndbg.git
RUN cd pwndbg && bash setup.sh

RUN git clone https://github.com/Gallopsled/pwntools.git
RUN cd pwntools && pip install --no-cache-dir -Ue .

RUN apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;


RUN mkdir                /challenge
WORKDIR                  /challenge
COPY qemu-arm            /challenge/
COPY superman            /challenge/
COPY close               /challenge/
COPY hello_world.payload /challenge/

# ENTRYPOINT socat TCP-LISTEN:1337,fork,reuseaddr,bind=0.0.0.0 EXEC:"./qemu-arm ./superman"

