#
# DevShop Core Dockerfile Template
#
# This image contains the environment variables and DevShop source code.
#
# It does NOT include the ability to run the CLI because we must rely on role containers for installation.
#
# This image is used so that every DevShop container built from `devshop/core` will have the same version of DevShop source, including the Ansible roles.
#
FROM devshop/ansible:centos7
LABEL maintainer="Jon Pugh"

# Path to DevShop source
ENV DEVSHOP_PATH /usr/share/devshop

# COPY files in. It is the fastest and most reliable way to install the exact source code we expect.
COPY ./ $DEVSHOP_PATH
RUN echo "Copied DevShop Source. \nVersion: `cd $DEVSHOP_PATH && git log -1`"

# The command to run on container build
ENV DEVSHOP_DOCKER_COMMAND_BUILD 'echo "\n\n DevShop Core Docker Image build complete!"'

# Set PATH variable to include devshop scripts and bin.
# bin does not get populated until composer install, so include the scripts dir too.
ENV PATH="${DEVSHOP_PATH}/bin:${DEVSHOP_PATH}/scripts:${PATH}"

# The command to run when the container starts.