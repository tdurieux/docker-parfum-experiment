FROM phusion/baseimage:0.11

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
ARG GIT_REV
ENV SPRESENSE_GIT_REV $GIT_REV
RUN apt-get update && apt-get install --no-install-recommends -y wget clang-format vim-common bzip2 make cmake --install-recommends && rm -rf /var/lib/apt/lists/*;
RUN wget https://raw.githubusercontent.com/sonydevworld/spresense/master/install-tools.sh
RUN mkdir -p /spresenseenv/usr
RUN bash -c 'echo "#!/bin/bash" > /usr/bin/sudo'
RUN bash -c 'echo "\$@" >> /usr/bin/sudo'
RUN chmod +x /usr/bin/sudo
ENV HOME /
RUN mkdir -p $HOME/spresenseenv/usr
RUN bash  ./install-tools.sh
ENV PATH "$PATH:/$HOME/spresenseenv/usr/bin"
RUN ldconfig
RUN rm -fv /*tar.bz2

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
