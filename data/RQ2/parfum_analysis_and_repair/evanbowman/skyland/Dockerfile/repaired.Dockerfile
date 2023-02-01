FROM ubuntu:18.04


RUN apt update && \
    apt -y --no-install-recommends install git && \
    apt -y --no-install-recommends install cmake && \
    apt -y --no-install-recommends install wget && \
    apt -y --no-install-recommends install gpg && \
    apt -y --no-install-recommends install xz-utils && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install curl && \
    apt -y --no-install-recommends install pkg-config && rm -rf /var/lib/apt/lists/*;

# NOTE: I am pulling the deb from one of my own releases. DevkitPro has deleted
# releases from their repository in the past, so I don't trust them to provide a
# stable download link.
RUN wget https://github.com/evanbowman/blind-jump-portable/releases/download/0.0.1/devkitpro-pacman.amd64.deb && \
    dpkg -i devkitpro-pacman.amd64.deb && \
    dkp-pacman -S --noconfirm gba-dev


ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=${DEVKITPRO}/devkitARM
ENV DEVKITPPC=${DEVKITPRO}/devkitPPC


WORKDIR /root
RUN git clone https://github.com/evanbowman/blind-jump-portable.git


WORKDIR /root/blind-jump-portable/build
RUN cmake -DCMAKE_TOOLCHAIN_FILE=$(pwd)/devkitarm.cmake .


ENTRYPOINT ["/bin/bash"]
