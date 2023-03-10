FROM devshop/base:ubuntu1804
LABEL maintainer="Jon Pugh"

# Ansible configuration path
ENV DEVSHOP_ANSIBLE_PATH /etc/ansible

# Install Ansible
# The script is put into /tmp because it is only needed once.
COPY ./install/devshop-install-prerequisites.sh /tmp/devshop-install-prerequisites.sh
RUN bash /tmp/devshop-install-prerequisites.sh

# Prepare Ansible folder, config & inventory
RUN mkdir -p ${DEVSHOP_ANSIBLE_PATH}
COPY ./docker/ansible/inventory  ${DEVSHOP_ANSIBLE_PATH}/hosts
COPY ./docker/ansible/ansible.cfg  ${DEVSHOP_ANSIBLE_PATH}/ansible.cfg

RUN \
echo "\n\n\
DevShop/Ansible Container build complete! \n\n\
Which Ansible? `which ansible && ansible --version`\n\n\
Which Python? `which python && python --version`\n\n\
"