FROM ubuntu

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install --no-install-recommends -y gcc-11 g++-11 && rm -rf /var/lib/apt/lists/*;
RUN LD_LIBRARY_PATH=/usr/local/lib64/:$LD_LIBRARY_PATH
RUN export LD_LIBRARY_PATH
RUN apt-get install --no-install-recommends -y valgrind && rm -rf /var/lib/apt/lists/*;

WORKDIR /corium
COPY CoriumC .
COPY main.cor .
RUN chmod +x CoriumC
CMD ["./CoriumC"]

