FROM fedora

RUN dnf -y install \
    make \
    golang \
    bats \
    btrfs-progs-devel \
    device-mapper-devel \
    glib2-devel \
    gpgme-devel \
    libassuan-devel \
    libseccomp-devel \
    git \
    bzip2 \
    go-md2man \
    runc \
    containers-common

# Workaround - the first install somehow leaves the golang in a bad state
RUN dnf -y install golang

ARG GIT_USER_NAME
RUN git config --global user.name "$GIT_USER_NAME"

ARG GIT_USER_EMAIL
RUN git config --global user.email "$GIT_USER_EMAIL"

#RUN mkdir /root/buildah && \
#    cd /root/buildah && \
#    git clone https://github.com/harness/buildah.git ./src/github.com/containers/buildah

RUN echo "alias bahrm='buildah rm --all && buildah rmi --all'" >> /root/.bashrc
RUN echo "alias bahbi='cd /root/buildah/src/github.com/containers/buildah && make && sudo make install && cd -'" >> /root/.bashrc

WORKDIR /root/buildah/src/github.com/containers/buildah