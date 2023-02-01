FROM ubuntu:16.04


RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  less \
  ssh \
  sudo \
  vim && rm -rf /var/lib/apt/lists/*;

#RUN ssh-keygen -q -t rsa -f /root/.ssh/id_rsa
#RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update
RUN apt-get install --no-install-recommends -y ansible && rm -rf /var/lib/apt/lists/*;

ENV PATH $PATH:/root/
WORKDIR /root
CMD cd build/damp/ ; ansible-playbook -i hostfile setup.yml --limit localhost ; /bin/bash

