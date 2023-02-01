FROM ubuntu:18.04

# Install build dependencies
RUN apt-get update && apt-get -y --no-install-recommends install sudo build-essential python python3 \
    uuid-dev nasm openssl gcc-multilib git m4 bison flex qemu-system-x86 && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 0

# Install ACPICA Utilities
ADD http://ftp.br.debian.org/debian/pool/main/a/acpica-unix/acpica-tools_20200925-6_amd64.deb /tmp
RUN cd /tmp && \
    dpkg -i acpica-tools_20200925-6_amd64.deb && \
    rm *.deb && \
    apt-get install -y -f && \
    apt-get -y --no-install-recommends install python3-distutils && rm -rf /var/lib/apt/lists/*;

# Install stitching dependencies
RUN apt-get install -y --no-install-recommends libxcb1 \
    libxcb-icccm4 libxcb-image0 libxcb-keysyms1 \
    libxcb-randr0 libxcb-render-util0 libxcb-shape0 \
    libxcb-sync1 libxcb-xfixes0 libxcb-xinerama0 \
    libxkbcommon-x11-0 unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install UTF8 as default locale
ENV LANG=en_US.UTF-8
RUN apt-get install --no-install-recommends -y locales && \
    apt-get clean && \
    locale-gen ${LANG} && update-locale LANG=${LANG} && rm -rf /var/lib/apt/lists/*;

# Add a user account, give sudo access
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

USER docker
RUN git config --global user.name "User" && git config --global user.email "user@example.com"
CMD /bin/bash
