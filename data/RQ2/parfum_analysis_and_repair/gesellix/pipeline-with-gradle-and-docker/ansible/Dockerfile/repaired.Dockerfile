FROM ubuntu:14.04

ENV TZ Europe/Berlin

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install --no-install-recommends -y software-properties-common && apt-add-repository ppa:ansible/ansible \
    && apt-get update \
    && apt-get install --no-install-recommends -y ansible python python-simplejson python-setuptools \
    && easy_install pip && rm -rf /var/lib/apt/lists/*;

ENV HOME /root

CMD ["ansible", "--version"]

ENV ANSIBLE_HOSTS /ansible/hosts
ENV ANSIBLE_LIBRARY /ansible/library
WORKDIR /ansible
ADD ./ /ansible
