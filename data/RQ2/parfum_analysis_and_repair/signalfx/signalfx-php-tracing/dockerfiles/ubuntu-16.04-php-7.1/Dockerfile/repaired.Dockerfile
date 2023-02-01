FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y vim valgrind software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install --no-install-recommends php7.1-cli php7.1-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends php7.1-curl php7.1-opcache php7.1-xml php7.1-xmlrpc php7.1-phpdbg php7.1-json php7.1-gd -y && rm -rf /var/lib/apt/lists/*;
CMD ["bash"]

ENTRYPOINT ["/bin/bash", "-c"]
