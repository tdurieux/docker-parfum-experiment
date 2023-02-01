FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y redis-server python-fuse python-redis python-xattr python-libewf sleuthkit git python-setuptools libpython-dev exif binutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://dfrws.capibara.com/python-fadvise_6.0.0_amd64.deb
RUN wget https://dfrws.capibara.com/python-pyblake2_0.9.3_amd64.deb
RUN dpkg -i python-fadvise_6.0.0_amd64.deb
RUN dpkg -i python-pyblake2_0.9.3_amd64.deb

WORKDIR dfrws
RUN git clone https://github.com/pibara/MattockFS.git
WORKDIR MattockFS
RUN wget https://dfrws.capibara.com/macwd.E01
RUN python ./setup.py build
RUN python ./setup.py install
RUN useradd mattockfs -d /var/mattock -m
RUN cp bin/* /usr/local/bin/
RUN cp mattockfs.json /etc/
