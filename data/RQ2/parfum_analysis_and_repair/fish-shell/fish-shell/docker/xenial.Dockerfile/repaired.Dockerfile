FROM ubuntu:16.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
    build-essential \
    cmake \
    gettext \
    git \
    libncurses5-dev \
    locales \
    ninja-build \
    python3 \
    python3-pip \
    sudo \
  && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

# The python3-pexpect package on Xenial doesn't allow delaybeforesend to be None.
# Install pexpect with pip which is newer.
RUN pip3 install --no-cache-dir pexpect

RUN groupadd -g 1000 fishuser \
  && useradd -p $(openssl passwd -1 fish) -d /home/fishuser -m -u 1000 -g 1000 fishuser \
  && adduser fishuser sudo \
  && mkdir -p /home/fishuser/fish-build \
  && mkdir /fish-source \
  && chown -R fishuser:fishuser /home/fishuser /fish-source

USER fishuser
WORKDIR /home/fishuser

COPY fish_run_tests.sh /

CMD /fish_run_tests.sh
