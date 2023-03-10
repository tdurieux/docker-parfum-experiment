FROM ubuntu:latest
WORKDIR /tick

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y build-essential cmake curl git swig patchelf unzip libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev && rm -rf /var/lib/apt/lists/*;

ENV PATH="/root/.pyenv/bin:$PATH"

# Installing pyenv
RUN curl -f -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# Installing googletest
RUN git clone https://github.com/google/googletest.git && \
	(cd googletest && mkdir -p build && cd build && cmake .. && make && make install) && \
	rm -rf googletest

# Installing necessary python versions
RUN pyenv install 3.5.3 && pyenv install 3.6.1

COPY requirements.txt requirements.txt

RUN eval "$(pyenv init -)" && \
    pyenv local 3.5.3 && pip install --no-cache-dir -r requirements.txt -U pip && pip install --no-cache-dir tensorflow && \
    pyenv local 3.6.1 && pip install --no-cache-dir -r requirements.txt -U pip && pip install --no-cache-dir tensorflow


LABEL maintainer "soren.poulsen@polytechnique.edu"
