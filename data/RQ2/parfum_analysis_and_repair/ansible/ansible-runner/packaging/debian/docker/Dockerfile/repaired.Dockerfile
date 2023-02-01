FROM debian:buster

RUN apt-get update && apt-get install --no-install-recommends -y \
  make debhelper dh-python devscripts python-all python-setuptools python-pip \
  python-backports.functools-lru-cache pinentry-tty && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --config pinentry
RUN pip install --no-cache-dir -IU pip setuptools
RUN pip install --no-cache-dir -IU ansible
