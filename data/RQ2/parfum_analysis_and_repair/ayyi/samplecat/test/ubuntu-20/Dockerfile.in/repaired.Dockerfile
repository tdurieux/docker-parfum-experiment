FROM registry.gitlab.com/ayyi.org/docker/ubuntu-20

/* Includes support for running Opengl applications.                  */
/* Ffmpeg included for creating test data (adds ~100MB to image size) */
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \\ && rm -rf /var/lib/apt/lists/*; \

#include "dependencies
ADD scripts/Makefile /root/

CMD make
