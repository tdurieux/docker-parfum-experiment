FROM ubuntu:20.04
# only works with Docker >= 1.9
#ARG BUILD_USER
#ARG GITHUB_USER
#ARG PACKAGER_NAME
#ARG PACKAGER_MAIL

ENV BUILD_USER
ENV GITHUB_USER
ENV PACKAGER_NAME ""
ENV PACKAGER_MAIL

# skip install suggested and recommended packages to keep the container as small as possible
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London
RUN apt-get update && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --no-install-suggests -y \
  vim-nox \
  aptitude \
  build-essential \
  devscripts \
  dpkg-dev \
  git \
  bash \
  sudo \
  ca-certificates \
  bash-completion \
  wget \
  apt-file \
  fakeroot \
  debhelper \
  reprepro \
  strace \
  dh-systemd \
  openssh-client \
  unzip \
  dos2unix \
  subversion \
  quilt && rm -rf /var/lib/apt/lists/*;

RUN useradd $BUILD_USER --home /home/$BUILD_USER --shell /bin/bash
RUN mkdir /home/$BUILD_USER && chown $BUILD_USER.$BUILD_USER /home/$BUILD_USER
RUN cd /home/$BUILD_USER
RUN mkdir /home/$BUILD_USER/sources /home/$BUILD_USER/rpmbuild
RUN cd /home/$BUILD_USER/sources && git clone https://$GITHUB_USER@github.com/kaltura/platform-install-packages
RUN echo "PACKAGER_NAME=\"$PACKAGER_NAME\"\nPACKAGER_MAIL=$PACKAGER_MAIL" > /home/$BUILD_USER/sources/platform-install-packages/build/packager.rc
RUN cp /root/.bashrc /home/$BUILD_USER
RUN echo "DEBFULLNAME=\"$PACKAGER_NAME\"\nDEBEMAIL=$PACKAGER_MAIL\nexport DEBEMAIL DEBFULLNAME" >> /home/$BUILD_USER/.bashrc
RUN ln -s /home/$BUILD_USER/sources /home/$BUILD_USER/rpmbuild/SOURCES
RUN chown -R $BUILD_USER.$BUILD_USER /home/$BUILD_USER
