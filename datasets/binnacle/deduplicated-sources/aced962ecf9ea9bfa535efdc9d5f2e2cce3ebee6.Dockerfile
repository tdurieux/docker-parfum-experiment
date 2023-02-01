FROM fedora:29
RUN yum update -y && \
    yum install -y git zip make gcc-c++ rpmdevtools \
        alsa-lib-devel pulseaudio-libs-devel \
        boost-devel \
        qt4-devel && \
    rm -Rf /var/cache/yum
WORKDIR /build/zxtune
RUN git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo -e "platform=linux\narch=x86_64\npackaging=rpm\ndistro=fedora\ntools.moc=moc-qt4\ntools.uic=uic-qt4\ntools.python=python3" > variables.mak
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["package", "-C", "apps/bundle"]
