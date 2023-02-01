FROM opensuse/leap

/* - includes support for running Opengl applications */
RUN zypper mr -r -a && zypper --non-interactive install --no-recommends \\

#include "dependencies"

RUN echo "alias ll='ls -l'" >> /root/.bashrc
WORKDIR /root
ADD add_samples /root/
ADD scripts/Makefile /root/

CMD make