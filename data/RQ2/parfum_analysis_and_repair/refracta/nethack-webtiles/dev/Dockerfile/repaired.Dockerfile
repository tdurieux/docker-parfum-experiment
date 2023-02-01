FROM ubuntu:bionic

WORKDIR /usr/src
RUN apt-get -y update && \
        apt-get install --no-install-recommends -y \
        gcc git cmake bison flex gdb curl g++ libncurses5-dev ttyrec nginx tmux nano && \
        curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
        apt-get install --no-install-recommends -y nodejs && \
        git clone https://github.com/json-c/json-c.git && \
        mkdir jsonc-build && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/jsonc-build
RUN cmake ../json-c && \
        make install
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib

WORKDIR /usr/src/NetHack-Webtiles

CMD service nginx start
