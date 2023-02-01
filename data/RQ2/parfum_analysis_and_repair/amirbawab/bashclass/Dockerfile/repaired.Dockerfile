FROM ubuntu:16.04
ENV HOME /root

# Intall required packages
RUN apt-get update
RUN apt-get install --no-install-recommends -y git curl wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ make && rm -rf /var/lib/apt/lists/*;

# Install cmake
RUN curl -f "https://cmake.org/files/v3.9/cmake-3.9.0-rc3.tar.gz" > /tmp/cmake.tar.gz
RUN cd /tmp; tar -xf cmake.tar.gz && rm cmake.tar.gz
WORKDIR "/tmp/cmake-3.9.0-rc3"
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; make install

# Install boost
RUN curl -f -L "https://downloads.sourceforge.net/project/boost/boost/1.63.0/boost_1_63_0.tar.gz" > /tmp/boost.tar.gz
RUN cd /tmp; tar -xf boost.tar.gz && rm boost.tar.gz
WORKDIR "/tmp/boost_1_63_0/"
RUN ./bootstrap.sh --prefix=/usr/local; ./b2 install

# Install BASH4.4
RUN curl -f -L "https://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz" > /tmp/bash-4.4.tar.gz
RUN cd /tmp; tar -xf bash-4.4.tar.gz && rm bash-4.4.tar.gz
WORKDIR  /tmp/bash-4.4
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; make install
RUN mv /bin/bash /bin/bash.old
RUN ln -s /usr/local/bin/bash /bin/bash

# Install BashClass
RUN cd $HOME; git   clone https://github.com/amirbawab/BashClass
WORKDIR $HOME/BashClass
RUN git submodule update --init --recursive
RUN cmake . -DSYNTAX_ERRORS="${PWD}/resources/src/syntax_errors.json"\
            -DSYNTAX_GRAMMAR="${PWD}/resources/src/grammar.json" \
            -DLEXICAL_ERRORS="${PWD}/resources/src/lexical_errors.json"\
            -DLEXICAL_CONFIG="${PWD}/resources/src/lexical_config.json"\
            -DLEXICAL_STATE_MACHINE="${PWD}/resources/src/lexical_graph.json"
RUN make bashcdev
RUN make generate_files
RUN cmake . -DSYNTAX_ERRORS="${PWD}/resources/src/syntax_errors.json"  \
            -DSYNTAX_GRAMMAR="${PWD}/resources/src/grammar.json" \
            -DLEXICAL_ERRORS="${PWD}/resources/src/lexical_errors.json"\
            -DLEXICAL_CONFIG="${PWD}/resources/src/lexical_config.json"\
            -DLEXICAL_STATE_MACHINE="${PWD}/resources/src/lexical_graph.json"
RUN make bashc

CMD /bin/bash
