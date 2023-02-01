FROM debian:9
LABEL org.opencontainers.image.authors="enrico.m.crisostomo@gmail.com>"

RUN apt-get -y update && apt-get install --no-install-recommends -y git autoconf automake gettext autopoint libtool make g++ texinfo curl && rm -rf /var/lib/apt/lists/*;

ENV ROOT_HOME /root
ENV FSWATCH_BRANCH @ax_git_current_branch@

WORKDIR ${ROOT_HOME}
RUN git clone https://github.com/emcrisostomo/fswatch.git

WORKDIR ${ROOT_HOME}/fswatch
RUN git checkout ${FSWATCH_BRANCH}
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j

CMD ["/bin/bash"]
