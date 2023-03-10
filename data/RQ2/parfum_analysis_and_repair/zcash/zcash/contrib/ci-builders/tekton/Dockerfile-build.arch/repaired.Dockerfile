ARG FROMBASEOS
ARG FROMBASEOS_BUILD_TAG
FROM $FROMBASEOS:$FROMBASEOS_BUILD_TAG

RUN pacman -Syyu --noconfirm \
    && pacman -S --noconfirm \
      base-devel \
      git \
      python3 \
      python-pip \
      ncurses \
      wget

RUN sudo link /lib/libtinfo.so.6 /lib/libtinfo.so.5