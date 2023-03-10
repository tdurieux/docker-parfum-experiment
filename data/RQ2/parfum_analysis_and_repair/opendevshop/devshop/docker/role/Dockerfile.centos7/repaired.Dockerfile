#
# DevShop Role Container Dockerfile Template
#
FROM devshop/core:centos7
LABEL maintainer="Jon Pugh"

# The path to the default ansible playbook for this image.
ENV DEVSHOP_ANSIBLE_PLAYBOOK ./role/play.yml
ENV ANSIBLE_PLAYBOOK $DEVSHOP_PATH/$DEVSHOP_ANSIBLE_PLAYBOOK

# Ansible Inventory file
ENV DEVSHOP_ANSIBLE_INVENTORY ./role/inventory
ENV DEVSHOP_ANSIBLE_INVENTORY_DESTINATION /etc/ansible/hosts
ENV DEVSHOP_ANSIBLE_INVENTORY_INFO_COMMAND "ansible-inventory --list --yaml"
ENV DEVSHOP_ANSIBLE_GROUP_NAME local

# Options passed to ansible-playbook during docker build.ENV DEVSHOP_ANSIBLE_BUILDTIME_OPTIONS "-vv --skip-tags runtime"
ENV DEVSHOP_ANSIBLE_BUILDTIME_OPTIONS "--skip-tags runtime"

# Options passed to ansible-playbook during docker run or exec.
ENV DEVSHOP_ANSIBLE_RUNTIME_OPTIONS "--tags runtime"

# The command to run on container build
ENV DEFAULT_DEVSHOP_DOCKER_COMMAND_BUILD $DEVSHOP_PATH/scripts/devshop-ansible-playbook \
  $DEVSHOP_ANSIBLE_BUILDTIME_OPTIONS

# Set DEVSHOP_DOCKER_COMMAND_BUILD from the Default so we can unset it later.
ENV DEVSHOP_DOCKER_COMMAND_BUILD $DEFAULT_DEVSHOP_DOCKER_COMMAND_BUILD

# The command to run when the container starts.
ENV DEFAULT_DEVSHOP_DOCKER_COMMAND_RUN $DEVSHOP_PATH/scripts/devshop-ansible-playbook \
  $DEVSHOP_ANSIBLE_RUNTIME_OPTIONS

# Set DEVSHOP_DOCKER_COMMAND_RUN from the Default so we can unset it later.
ENV DEVSHOP_DOCKER_COMMAND_RUN $DEFAULT_DEVSHOP_DOCKER_COMMAND_RUN

RUN echo "Running $DEVSHOP_ANSIBLE_INVENTORY_INFO_COMMAND ...\n" && \
  $DEVSHOP_ANSIBLE_INVENTORY_INFO_COMMAND

RUN echo "Running $DEVSHOP_DOCKER_COMMAND_BUILD ...\n" && \
  $DEVSHOP_DOCKER_COMMAND_BUILD

# Set CMD to ansible-playbook with runtime tag.
# REMEMBER: This command is not run until a container using this image is started.