FROM alpine

ENV ANSIBLE_HOST_KEY_CHECKING=False

RUN apk add --no-cache ansible gcc python3-dev libc-dev libffi-dev openssl-dev
RUN apk add --no-cache python3 py3-pip openssh-client sshpass
RUN pip3 install --no-cache-dir --upgrade paramiko
RUN pip3 install --no-cache-dir docker

COPY hosts /hosts

COPY ansible.cfg /etc/ansible/ansible.cfg

COPY entrypoint.sh /entrypoint.sh

CMD ["sh", "/entrypoint.sh"]