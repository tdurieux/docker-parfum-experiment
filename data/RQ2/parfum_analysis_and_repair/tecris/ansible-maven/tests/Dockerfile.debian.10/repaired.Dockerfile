FROM debian:10

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y \
		build-essential \
		python3 \
		python3-dev \
		python3-pip \
	&& \
	pip3 install --no-cache-dir dumb-init ansible && \
	apt-get remove -y \
		build-essential \
		python3-dev \
		python3-pip \
	&& \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	:

# Install Ansible inventory file
RUN mkdir -p /etc/ansible \
    && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENTRYPOINT dumb-init python3 -c 'while True: pass'
