FROM gentoo/stage3-amd64-hardened
ARG CTNG_UID=1000
ARG CTNG_GID=1000
RUN groupadd -g $CTNG_GID ctng
RUN useradd -d /home/ctng -m -g $CTNG_GID -u $CTNG_UID -s /bin/bash ctng
RUN wget -O /sbin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod a+x /sbin/dumb-init
RUN echo 'export PATH=/opt/ctng/bin:$PATH' >> /etc/profile
ENTRYPOINT [ "/sbin/dumb-init", "--" ]