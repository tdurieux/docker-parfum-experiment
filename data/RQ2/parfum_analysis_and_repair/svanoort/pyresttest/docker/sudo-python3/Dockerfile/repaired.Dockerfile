FROM python:3.4.3-wheezy
MAINTAINER svanoort <samvanoort@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN useradd mysudoer -u @@MYUSERID@@
RUN echo 'mysudoer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers