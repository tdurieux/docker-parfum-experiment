ARG  from
FROM ${from}

ENV  CFLAGS=-w CXXFLAGS=-w

RUN pacman -Sy --noconfirm \
      diffutils \
      fontconfig \
      freetype2 \
      libx11 \
      libxext \
      libxrender \
      libjpeg-turbo \
      libpng \
      make \
      gcc \
      && pacman -Scc --noconfirm