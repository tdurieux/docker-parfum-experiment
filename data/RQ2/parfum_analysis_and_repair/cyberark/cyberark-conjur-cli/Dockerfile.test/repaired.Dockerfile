FROM ubuntu:21.10
ENV INSTALL_DIR=/opt/cyberark-conjur-cli
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install --no-install-recommends -y bash \
                    binutils \
                    build-essential \
                    curl \
                    git \
                    jq \
                    libffi-dev \
                    libssl-dev \
                    libsqlite3-dev \
                    python3-dev \
                    gnome-keyring \
                    dbus-x11 \
                    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $INSTALL_DIR
WORKDIR $INSTALL_DIR

# Install Python 3.10.1 using pyenv, wheel and required libs
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

COPY ./requirements.txt $INSTALL_DIR/
RUN curl -f -L -s https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && eval "$(pyenv init --path)" \
    && env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.10.1 \
    && pyenv global 3.10.1 \
    && pip install --no-cache-dir wheel \
    && pip install --no-cache-dir -r requirements.txt

COPY . $INSTALL_DIR

COPY ./test/configure_test_executor.sh /configure_test_executor.sh

ENTRYPOINT ["./test/configure_test_executor.sh"]
