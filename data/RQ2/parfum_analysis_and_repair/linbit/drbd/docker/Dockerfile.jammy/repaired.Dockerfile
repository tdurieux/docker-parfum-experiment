FROM ubuntu:jammy

RUN apt-get update && apt-get install --no-install-recommends -y kmod gnupg wget make gcc patch elfutils curl && \
	apt-get install --no-install-recommends -y python3-setuptools && apt-get clean && \
	cd /tmp && wget https://github.com/LINBIT/python-lbdist/archive/master.tar.gz && \
	tar xvf master.tar.gz && \
	( cd python-lbdist-master && python3 setup.py install ) && \
	rm -rf python-lbdist-master master.tar.gz && rm -rf /var/lib/apt/lists/*;

COPY /drbd.tar.gz /

COPY /pkgs /pkgs

COPY /entry.sh /
RUN chmod +x /entry.sh
ENTRYPOINT /entry.sh
