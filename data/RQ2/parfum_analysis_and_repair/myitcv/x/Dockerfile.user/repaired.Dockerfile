FROM myitcv/x_monorepo:chrome_${CHROME_CHANNEL}_${GO_VERSION}

ARG USER
ARG UID
ARG GID
ARG DOCKER_WORKING_DIR

ENV PATH=/vbash/bin:/home/$USER/.local/bin:$PATH
ENV GOPATH=/home/$USER/gopath

RUN groupadd -g $GID $USER && \
    adduser --uid $UID --gid $GID --disabled-password --gecos "" $USER

RUN sudo -i -u $USER mkdir -p /home/$USER/gopath/src/myitcv.io

# enable sudo
RUN usermod -aG sudo $USER
RUN echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

RUN usermod -aG docker $USER

USER $USER