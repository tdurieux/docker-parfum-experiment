# VERSION               0.0.1

FROM       ubuntu:14.04
MAINTAINER AbhishekKr <abhikumar163@gmail.com>

RUN apt-get -y update && apt-get -y --no-install-recommends install curl vim bash git ipython && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sk https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
RUN git clone https://github.com/torch/distro.git /opt/torch --recursive
RUN cd /opt/torch ; /opt/torch/install.sh

ENV PATH /opt/toch/bin:$PATH

RUN th -h
