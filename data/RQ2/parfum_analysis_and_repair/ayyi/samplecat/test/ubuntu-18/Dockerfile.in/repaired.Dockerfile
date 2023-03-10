/* gcc 7.3 */
FROM ubuntu:18.04

/* - includes support for running Opengl applications */
/* - ffmpeg included for creating test data (adds ~100MB to image size) */
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \\ && rm -rf /var/lib/apt/lists/*; \

#include "dependencies"

RUN echo "alias ll='ls -l'" >> /root/.bashrc
WORKDIR /root
ADD add_samples /root/
ADD scripts/Makefile /root/

CMD make
