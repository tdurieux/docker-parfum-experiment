#
# Dockerfile-python
#
# Copyright (c) 2016-2017 Junpei Kawamoto
#
# This software is released under the MIT License.
#
# http://opensource.org/licenses/mit-license.php
#
{{define "package"}}
# Install apt packages.
RUN apt-get update && \
    apt-get install --no-install-recommends -y python python-pip aria2 zlib1g-dev libreadline6-dev \
                       libbz2-dev libsqlite3-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Update pip
RUN pip install --no-cache-dir --upgrade pip
# Install pyenv
RUN curl -f -sSL https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
{{end}}

{{define "version"}}
# Install a specific python version
ENV PYTHON_BUILD_ARIA2_OPTS "-x 10 -k 1M"
RUN PATH="/root/.pyenv/bin:$PATH" && \
    echo "Set Python $VERSION" && \
    eval "$(pyenv init -)" && \
    eval "$(pyenv virtualenv-init -)" && \
    PYVERSION=$(pyenv install -l | sed "s/ //g" | grep -E "^$VERSION($|[^-])" | tail -1) && \
    env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install -s -v $PYVERSION && \
    pyenv local $PYVERSION
{{end}}
