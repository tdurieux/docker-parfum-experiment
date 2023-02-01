FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
# toolchain
RUN apt-get install --no-install-recommends -yq cmake extra-cmake-modules g++ git gettext && rm -rf /var/lib/apt/lists/*;
# kf5 and qt5 libraries
RUN apt-get install --no-install-recommends -yq libkf5i18n-dev libkf5notifications-dev libkf5service-dev \
      libkf5windowsystem-dev libkf5plasma-dev qtbase5-dev qtdeclarative5-dev \
      plasma-framework && rm -rf /var/lib/apt/lists/*;

# required by tests
RUN apt-get install --no-install-recommends -yq xvfb && rm -rf /var/lib/apt/lists/*;
