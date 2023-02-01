FROM debian:11.3

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo '\
deb-src http://deb.debian.org/debian bullseye main\n\
deb-src http://security.debian.org/debian-security bullseye-security main\n\
deb-src http://deb.debian.org/debian bullseye-updates main\n\
' > /etc/apt/sources.list.d/debian-sources.list

RUN apt-get -y update && \
    apt-get -y install sudo \
                       xorriso \
                       git \
                       gettext \
                       unifont \
                       mtools \
                       zip \
                       rsync \
                       udev \
                       python3

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN apt-get -y build-dep grub2

RUN echo "sgdbuilder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sgdbuilder-sudo
RUN useradd -u 1004 sgdbuilder
ADD --chown=1004:1004 . /supergrub2-repo
RUN mkdir /supergrub2-build
RUN chown 1004:1004 /supergrub2-build

USER sgdbuilder
RUN git clone /supergrub2-repo /supergrub2-build
WORKDIR /supergrub2-build
CMD ./grub-build-001-prepare-build && ./grub-build-002-clean-and-update && ./grub-build-003-build-all && ./grub-build-005-install-all && ./supergrub-official-release && ./supergrub-release-changes $PREVIOUS_VERSION
