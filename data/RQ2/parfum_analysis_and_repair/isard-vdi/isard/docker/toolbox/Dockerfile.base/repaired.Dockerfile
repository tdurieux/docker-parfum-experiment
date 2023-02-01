FROM fedora:36 as production
MAINTAINER isard <info@isard.com>

COPY --from=filebrowser/filebrowser /filebrowser /filebrowser

# guestfs, libvirt, libvirt python3 devel, libqcow
RUN dnf install -y libguestfs libguestfs-tools-c virt-v2v \
                    libvirt-daemon libvirt-daemon-config-network \
                    python3-pip python3-libvirt python3-libguestfs \
                    git autoconf automake pkg-config gettext-devel libtool python3-devel gcc \
                    && git clone https://github.com/libyal/libqcow.git \
                    && cd libqcow && sh synclibs.sh && sh autogen.sh && python3 setup.py install \
                    && cd / && rm -r /libqcow \
                    && pip3 install --no-cache-dir --upgrade pip \
                    && pip3 install --no-cache-dir requests xmltodict ipython rethinkdb==2.3.0.post6 python-jose==3.3.0 python-iptables==1.0.0 pythonping==1.0.15 \
                    && dnf remove -y git autoconf automake pkg-config gettext-devel libtool python3-devel gcc \
                    && dnf clean all \
                    && dnf autoremove -y \
                    && rm -rf /var/cache/yum

# This is required for virt-v2v because neither systemd nor
# root libvirtd runs, and therefore there is no virbr0, and
# therefore virt-v2v cannot set up the network through libvirt.
ENV LIBGUESTFS_BACKEND direct

# https://bugzilla.redhat.com/show_bug.cgi?id=1045069
RUN useradd -ms /bin/bash v2v
#USER v2v
#WORKDIR /home/v2v

COPY docker/toolbox/src /src
COPY docker/toolbox/init.sh /init.sh

CMD ["/bin/sh","/init.sh"]
