FROM bernddoser/docker-devel-cpp:ubuntu-14.04-gcc-4.9-gtest-1.8.0

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    graphviz \
    mscgen \
    texlive \
    texlive-lang-english \
    texlive-latex-extra \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.5.linux.bin.tar.gz \
 && tar xf doxygen-1.8.5.linux.bin.tar.gz \
 && rm doxygen-1.8.5.linux.bin.tar.gz \
 && ln -sf /opt/doxygen-1.8.5/bin/doxygen /usr/bin/doxygen

WORKDIR /
