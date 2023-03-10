FROM alpine:3.4
RUN apk update

# Install Ansible
RUN apk add --no-cache git ansible
RUN mkdir /etc/ansible

# Install Ansible inventory file
RUN (echo "[local]"; echo "localhost ansible_connection=local") > /etc/ansible/hosts
