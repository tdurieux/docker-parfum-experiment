FROM hypriot/rpi-alpine:3.4

RUN apk --update add \
		bash \
		ca-certificates \
		git \
		openssl \
		openssh-client \
		p7zip \
		python \
		py-lxml \
		py-pip \
		rsync \
		sshpass \
		sudo \
                subversion \
		zip \
    	&& apk --update add --virtual \
		build-dependencies \
		python-dev \
		libffi-dev \
		openssl-dev \
		build-base \
	&& pip install --no-cache-dir --upgrade \
		pip \
		cffi \
	&& pip install --no-cache-dir \
		ansible==2.2.1.0 \
		boto==2.45.0 \
   boto3==1.4.4 \
		docker-py==1.10.6 \
		dopy==0.3.7 \
		pywinrm >=0.1.1 \
		pyvmomi==6.0.0.2016.6 \
		pysphere >=0.1.7 \
	&& apk del build-dependencies \
	&& rm -rf /var/cache/apk/*

RUN	mkdir -p /etc/ansible \
	&& echo 'localhost' > /etc/ansible/hosts \
	&& mkdir -p ~/.ssh && touch ~/.ssh/known_hosts \

ONBUILD	WORKDIR	/tmp
ONBUILD	COPY 	. /tmp
ONBUILD	RUN	ansible -c local -m setup all > /dev/null
CMD ["bash"]
