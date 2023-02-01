FROM rycus86/arm64v8-debian-qemu
VOLUME ["~/.teos"]
WORKDIR /srv
ADD . /srv/python-teos
RUN apt-get update && apt-get -y --no-install-recommends install python3 python3-pip libffi-dev libssl-dev pkg-config libleveldb-dev libzmq3-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir ~/.teos && cd python-teos && pip3 install --no-cache-dir .
WORKDIR /srv/python-teos
EXPOSE 9814/tcp
ENTRYPOINT [ "/srv/python-teos/docker/entrypoint.sh" ]