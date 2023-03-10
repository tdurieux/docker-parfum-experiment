#
# DevShop Role: Server
#
# All-in-one devshop server.
#
FROM devshop/role:centos7
LABEL maintainer="Jon Pugh"

# The last thing the user sees in the logs.
ENV DOCKER_COMMAND_POST devshop login

# DEVSHOP_ANSIBLE_GROUP_NAME string must match in 'inventory' and 'play.yml' files.

ENV DEVSHOP_ANSIBLE_PLAYBOOK ./roles/devshop.server/play.yml
ENV ANSIBLE_PLAYBOOK $DEVSHOP_PATH/$DEVSHOP_ANSIBLE_PLAYBOOK

ENV DEVSHOP_ANSIBLE_INVENTORY ./roles/devshop.server/inventory
ENV DEVSHOP_ANSIBLE_GROUP_NAME devshop_server

COPY $DEVSHOP_ANSIBLE_INVENTORY $DEVSHOP_ANSIBLE_INVENTORY_DESTINATION

# Copy this roles dependencies into the image. Each role can decide what to copy in.
COPY ./roles ${DEVSHOP_ANSIBLE_PATH}/roles

# COPY files in. It is the fastest and most reliable way to install the exact source code we expect.
RUN rm -rf $DEVSHOP_PATH
RUN rm -rf $bin_dir/docker-*

COPY ./ $DEVSHOP_PATH
RUN echo "Copied DevShop Source. \nVersion: `cd $DEVSHOP_PATH && git log -1`"

# Set WORKDIR to expected users home.
WORKDIR /var/aegir

RUN \
  echo "Ansible Directory: `ls -la ${DEVSHOP_ANSIBLE_PATH}`" &&\
  echo "Roles Directory: `ls -la ${DEVSHOP_ANSIBLE_PATH}/roles`" &&\
  echo "Ansible Inventory: `cat ${DEVSHOP_ANSIBLE_PATH}/hosts`" &&\
  echo "Ansible Inventory: `ansible-inventory --yaml --list`" &&\
  echo "Ansible Playbook: `cat ${DEVSHOP_ANSIBLE_PATH}/play.yml`"

# Run ansible-playbook again with build-time options.