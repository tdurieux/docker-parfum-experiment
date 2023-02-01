FROM scratch
ADD com.valvesoftware.SteamRuntime.Sdk-amd64,i386-%RUNTIME%-sysroot.tar.gz /
WORKDIR /build
RUN \
 set -e; \
mkdir -p /run/systemd; \
echo 'docker' > /run/systemd/container; \
mkdir -p /prep; cd /prep; \
if [ -f /usr/bin/python3.5 ]; then \
  ln -sf python3.5 /usr/bin/python3; \
  curl -f https://bootstrap.pypa.io/pip/3.5/get-pip.py -o get-pip.py; \
else \
  curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
fi; \
if [ ! -f /usr/bin/unzip ]; then \
 apt-get update; apt-get -y --no-install-recommends install unzip; rm -rf /var/lib/apt/lists/*; fi; \
python3 ./get-pip.py; \
pip3 install --no-cache-dir meson mako; \
curl -f -LO http://mirrors.kernel.org/ubuntu/pool/main/n/nvidia-settings/libxnvctrl0_440.64-0ubuntu1_amd64.deb; \
curl -f -LO http://mirrors.kernel.org/ubuntu/pool/main/n/nvidia-settings/libxnvctrl-dev_440.64-0ubuntu1_amd64.deb; \
dpkg -i libxnvctrl0_440.64-0ubuntu1_amd64.deb libxnvctrl-dev_440.64-0ubuntu1_amd64.deb; \
cd /; rm -fr /prep; \
:

CMD ["/bin/bash"]
