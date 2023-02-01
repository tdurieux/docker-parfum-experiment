FROM fedora:latest

RUN dnf install -y dnf-plugins-core
RUN sudo dnf copr enable -y @virtmaint-sig/virt-preview

RUN dnf install -y python3-libvirt libvirt qemu-system-x86 python3-requests python3-pip libpq-devel gcc python3-devel httpd-devel redhat-rpm-config

COPY . /src
RUN pip install --no-cache-dir -r /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements-test.txt

RUN systemctl enable libvirtd
CMD [ "/sbin/init" ]
