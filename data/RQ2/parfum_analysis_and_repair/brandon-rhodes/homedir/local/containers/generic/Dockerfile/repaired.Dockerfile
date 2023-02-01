# Once the container is up and running, try something like:
#
# travis encrypt -r brandon-rhodes/pyephem SOMEVAR="secretvalue"

FROM ubuntu:21.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt upgrade -y -y
RUN apt install --no-install-recommends -y -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y -y less python2.7-dev python3-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -s python2.7 /usr/bin/python
CMD cd /mnt && /bin/bash
