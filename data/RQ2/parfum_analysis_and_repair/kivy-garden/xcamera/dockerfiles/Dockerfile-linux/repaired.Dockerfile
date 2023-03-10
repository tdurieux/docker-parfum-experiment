# Docker image for installing dependencies on Linux and running tests.
# Build with:
#   docker build --tag=kivy/xcamera-linux --file=dockerfiles/Dockerfile-linux .
# Run with:
# docker run kivy/xcamera-linux /bin/sh -c 'make test'
# Or using the entry point shortcut:
#   docker run kivy/xcamera-linux 'make test'
# For running UI:
#   xhost +"local:docker@"
#   docker run -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --device=/dev/video0:/dev/video0 kivy/xcamera-linux 'make run'
# Or for interactive shell:
#   docker run -it --rm kivy/xcamera-linux
FROM ubuntu:18.04

ENV USER="user"
ENV HOME_DIR="/home/${USER}"
ENV WORK_DIR="${HOME_DIR}"

# configure locale
RUN apt update -qq > /dev/null && apt install --yes --no-install-recommends \
    locales && \
    locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# install system dependencies
RUN apt update -qq > /dev/null && apt install --yes --no-install-recommends \
    make \
    sudo && rm -rf /var/lib/apt/lists/*;

# prepare non root env
RUN useradd --create-home --shell /bin/bash ${USER}
# with sudo access and no password
RUN usermod -append --groups sudo ${USER}
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# gives access to video so the camera can be accessed within the container
RUN gpasswd --add ${USER} video

USER ${USER}
WORKDIR ${WORK_DIR}
COPY Makefile requirements* ${WORK_DIR}/
RUN sudo apt update -qq > /dev/null \
    && sudo make system_dependencies && make virtualenv
COPY . ${WORK_DIR}
ENTRYPOINT ["./dockerfiles/start.sh"]
