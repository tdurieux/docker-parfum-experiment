ARG IMAGE
FROM ${IMAGE}

SHELL ["/bin/bash", "-i", "-c"]

ARG PYTHON_VERSION=3.7.5

## Install System Dependencies
RUN pacman -Syu --noconfirm git ruby rubygems gcc make gawk

## Install Pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && source ~/.bashrc \
    && curl -f -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
    && PYTHON_CONFIGURE_OPTS="--enable-shared" MAKE_OPTS="-j$(nproc)" pyenv install $PYTHON_VERSION \
    && source ~/.bashrc \
    && pyenv global $PYTHON_VERSION

## Install Arch Installer
RUN gem install --no-document fpm

## Install More Build Dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir fbs

ADD . home
COPY ./docker/installer/generator.sh generator.sh
ENTRYPOINT ["bash", "./generator.sh"]
