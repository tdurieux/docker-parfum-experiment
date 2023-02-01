FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive
# bucket credentials will be provided by docker-compose or k8s secrets, if needed
RUN ln -s /run/secrets/s3cfg/s3cfg /root/.s3cfg

RUN apt-get update && \
    apt-get -yq --no-install-recommends install \
	dumb-init python3-pip python3-setuptools python3-wheel python3-magic \
	python3-xattr python3-netifaces python3-cffi && \
	apt-get autoremove --purge -y && \
	rm -rf /var/lib/apt/lists/*

COPY curieconf-utils /curieconf-utils
RUN cd /curieconf-utils ; pip3 install --no-cache-dir .
COPY curieconf-client /curieconf-client
RUN cd /curieconf-client ; pip3 install --no-cache-dir .
RUN pip3 install -t /usr/local/lib/python3.7/dist-packages --no-cache-dir pyrsistent
COPY init /init

ENTRYPOINT ["/usr/bin/dumb-init", "/bin/bash", "/init/pull.sh"]
