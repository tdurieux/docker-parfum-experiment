FROM richxsl/rhel7

ARG N8N_VERSION

RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi

RUN \
	yum install -y gcc-c++ make && rm -rf /var/cache/yum

RUN \
	curl -f -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -

RUN \
	sudo yum install -y nodejs && rm -rf /var/cache/yum

# Set a custom user to not have n8n run as root
USER root

RUN npm_config_user=root npm install -g n8n@${N8N_VERSION} && npm cache clean --force;

WORKDIR /data

CMD "n8n"
