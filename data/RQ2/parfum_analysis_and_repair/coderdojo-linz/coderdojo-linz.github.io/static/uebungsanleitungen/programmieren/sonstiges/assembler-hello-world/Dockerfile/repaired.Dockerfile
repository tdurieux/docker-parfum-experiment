FROM ubuntu

# Install prerequisites
RUN apt-get update && apt-get install --no-install-recommends -qqy build-essential gdb libc6-dev-i386 curl git vim && rm -rf /var/lib/apt/lists/*;

# Install NASM
RUN curl -f --output nasm-2.12.02.tar.gz https://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.gz && \
    tar -xzf nasm-2.12.02.tar.gz --directory /usr/local/src && \
    cd /usr/local/src/nasm-2.12.02/ && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    cp nasm.1 /usr/local/man/man1 && \
    cp ndisasm.1 /usr/local/man/man1 && rm nasm-2.12.02.tar.gz

# Configure vim
RUN mkdir -p ~/.vim/syntax && \
    curl -f https://raw.githubusercontent.com/Shirk/vim-gas/master/syntax/gas.vim -o ~/.vim/syntax/gas.vim && \
    mkdir -p ~/.vim/ftdetect && \
    echo "au BufRead,BufNewFile *.asm set syntax=gas" > ~/.vim/ftdetect/mine.vim

RUN mkdir /src
COPY ./assembler-hello-world /src