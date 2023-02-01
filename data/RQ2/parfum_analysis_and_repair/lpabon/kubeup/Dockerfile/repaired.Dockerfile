FROM vagrantlibvirt/vagrant-libvirt:latest

RUN apt update \
    && apt install --no-install-recommends -y \
		rsync \
		python3-pip \
    && rm -rf /var/lib/apt/lists \
    ; rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir ansible

ENTRYPOINT ["entrypoint.sh"]
