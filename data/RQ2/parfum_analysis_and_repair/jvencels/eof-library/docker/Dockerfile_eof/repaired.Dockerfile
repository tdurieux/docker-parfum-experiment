ARG BASE_IMAGE=eoflibrary/elmerdev_of7:latest
# --build-arg BASE_IMAGE=eoflibrary/elmer84_of6_debug:latest

FROM $BASE_IMAGE

# Default user inside base image
ENV USER=openfoam USER_ID=98765 USER_GID=98765

USER root

RUN apt-get -y update && \
  apt-get install --no-install-recommends -y \
    sudo && \
  echo "openfoam:openfoam" | chpasswd && \
  adduser openfoam sudo && rm -rf /var/lib/apt/lists/*;

# Add EOF-Library
ADD ./ EOF-Library

# Update environment & install script for dynamic UID:GID mapping
RUN echo ". /home/openfoam/EOF-Library/etc/bashrc" >> .bashrc && \
  mv /home/openfoam/EOF-Library/docker/user-mapping.sh / && \
  chmod u+x /user-mapping.sh

ENTRYPOINT ["/user-mapping.sh"]
