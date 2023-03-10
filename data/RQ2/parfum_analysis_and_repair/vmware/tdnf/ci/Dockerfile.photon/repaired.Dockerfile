FROM photon:latest

RUN tdnf update  -y
RUN tdnf remove  -y toybox
RUN tdnf install -y --enablerepo=photon-debuginfo \
               build-essential cmake curl-devel rpm-build \
               libsolv-devel popt-devel sed createrepo_c glib libxml2 \
               findutils python3 python3-pip python3-setuptools \
               python3-devel valgrind gpgme-devel glibc-debuginfo \
               libxml2-devel openssl-devel zlib-devel sqlite-devel \
               python3-requests python3-urllib3 python3-pyOpenSSL \
               sudo shadow which

# this can to be removed once latest pytest gets published in photon
RUN pip3 install --no-cache-dir pytest flake8

RUN mkdir -p /var/lib/tdnf

CMD ["/bin/bash"]
