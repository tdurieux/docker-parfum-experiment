# https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/ - latter part of the blog

ARG DOCKER_USER_NAME
ARG FULL_GRAALVM_VERSION
FROM ${DOCKER_USER_NAME}/graalvm-demos:${FULL_GRAALVM_VERSION}

# Install xterm in order to be able to access it when running GUI apps
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
       x11vnc xvfb xterm \
       xfonts-75dpi xfonts-100dpi xfonts-base \
       libfontconfig1 libxrender1 libxtst6 \
       libgomp1 zlib1g liblzma5 libc6 \
       libbz2-1.0 bzip2 patch \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

RUN echo "gcc version: "; gcc --version
RUN echo "make version: "; make --version

# https://askubuntu.com/questions/161652/how-to-change-the-default-font-size-of-xterm#161704
RUN echo "exec xterm -maximized -fa 'Monospace' -fs 18" > \
         ~/.xinitrc && chmod +x ~/.xinitrc
RUN echo ""; echo "Contents of ~/.xinitrc"; echo ""; cat ~/.xinitrc; echo "";
RUN echo "xterm*font:     *-Monospace-*-*-*-18-*" > ~/.Xresources
RUN echo ""; echo "Contents of ~/.Xresources"; echo ""; cat ~/.Xresources; echo "";

# Adding environment variable to support older demos that rely on the GRAALVM_DIR env variable
ENV GRAALVM_DIR="${JAVA_HOME}"
RUN echo "GRAALVM_DIR=${GRAALVM_DIR}"
RUN echo "GRAALVM_HOME=${GRAALVM_HOME}"

LABEL maintainer="GraalVM team"
LABEL example_git_repo="https://github.com/graalvm/graalvm-demos"
LABEL graalvm_version=${FULL_GRAALVM_VERSION}
LABEL version=${FULL_GRAALVM_VERSION}

# manual: https://linux.die.net/man/1/x11vnc