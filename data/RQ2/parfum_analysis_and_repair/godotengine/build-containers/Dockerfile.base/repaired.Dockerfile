FROM fedora:36

WORKDIR /root

RUN dnf -y install --setopt=install_weak_deps=False \
      bash bzip2 curl file findutils git make nano patch pkgconfig python3-pip unzip which xz && \
    pip install --no-cache-dir scons==4.3.0

CMD /bin/bash
