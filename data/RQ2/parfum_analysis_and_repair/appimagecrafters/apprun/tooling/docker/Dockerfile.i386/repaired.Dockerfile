FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y check g++ pkg-config apt-transport-https wget patchelf g++-multilib libc6-dev-i386 && rm -rf /var/lib/apt/lists/*;

### install latest cmake from Kitware ppa
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ xenial main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null
RUN apt-get update
# Install the kitware-archive-keyring package to ensure that our keyring stays up to date as they rotate keys:
RUN rm /usr/share/keyrings/kitware-archive-keyring.gpg && apt-get install -y --no-install-recommends kitware-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

ENV TARGET_ARCH=i386
ENV TARGET_DEB_ARCH="i386"
ENV CFLAGS=-m32

RUN dpkg --add-architecture $TARGET_DEB_ARCH
RUN apt-get update
RUN apt-get install --no-install-recommends -y check:$TARGET_DEB_ARCH && rm -rf /var/lib/apt/lists/*;

ENV PKG_CONFIG_PATH=/usr/lib/$TARGET_DEB_ARCH-linux-gnu/pkgconfig

WORKDIR "/src"