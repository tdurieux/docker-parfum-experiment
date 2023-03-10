FROM registry.fedoraproject.org/fedora:rawhide
RUN dnf install git -y
RUN git --version
USER  1000:1000
VOLUME /repo
WORKDIR /repo
ENTRYPOINT mkdir git-archived && git archive HEAD -o git-archived/archival.tar.gz