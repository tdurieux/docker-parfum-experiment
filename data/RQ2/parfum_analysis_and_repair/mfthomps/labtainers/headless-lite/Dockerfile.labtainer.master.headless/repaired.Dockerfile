# student@ubuntu:~/labtainer/trunk/scripts/designer$ cat base_dockerfiles/Dockerfile.labtainer.master
#
# Create a master Labtainer image for use in running Labtainers from a container
# on any system that has Docker installed, withou having to install Labtainers.
# Thanks for Olivier Berger for this contribution.
#

FROM labtainers/labtainer.master.base

LABEL description="This is Docker image for the Labtainers master controller, stage 2"

# Continue to configure the image.

COPY --chown=labtainer:labtainer labtainer.tar /home/labtainer
RUN tar xf labtainer.tar && rm labtainer.tar
RUN rm labtainer.tar
RUN cd labtainer && ln -s trunk/scripts/labtainer-student
RUN cd labtainer && ln -s trunk/scripts/labtainer-instructor

RUN cd labtainer/trunk/scripts/labtainer-student/bin && ln -s ../../../setup_scripts/update-labtainer.sh

COPY --chown=labtainer:labtainer bashrc.labtainer.master /home/labtainer
RUN cat bashrc.labtainer.master >>/home/labtainer/.bashrc

ENV DISPLAY :0
ENV NO_AT_BRIDGE=1
ENV VNCHOST=novnc

COPY  --chown=labtainer:labtainer ./motd /etc/motd
COPY  --chown=labtainer:labtainer ./docker-entrypoint /
COPY  ./waitForX.sh /usr/bin/
COPY  --chown=labtainer:labtainer ./doterm.sh /home/labtainer/.doterm.sh
COPY  --chown=labtainer:labtainer ./doupdate.sh /home/labtainer/.doupdate.sh
RUN touch /home/labtainer/labtainer/.doupdate

# setup default pdf app, for opening URI links, in lab descriptions.
RUN mkdir -p /home/labtainer/.config
RUN xdg-mime default mupdf.desktop application/pdf
RUN mkdir -p /home/labtainer/labtainer_xfer
RUN mkdir -p /home/labtainer/.local/share/labtainers

RUN chmod 744 /docker-entrypoint
