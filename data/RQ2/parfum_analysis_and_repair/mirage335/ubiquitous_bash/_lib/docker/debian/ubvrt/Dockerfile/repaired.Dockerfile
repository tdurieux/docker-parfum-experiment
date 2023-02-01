FROM ubvrt/debian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y --no-install-recommends install \
ca-certificates \
curl \
x11-apps \
libgl1-mesa-glx libgl1-mesa-dri mesa-utils \
wget \
gnupg2 \
file \
build-essential \
fuse \
hicolor-icon-theme \
nano \
vim && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install default-jre && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install grub2 makedev linux-image-amd64 && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install cifs-utils nmap smbclient && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install lxde-core lxde task-lxde-desktop && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install kde-plasma-desktop kde-standard kde-full task-kde-desktop && rm -rf /var/lib/apt/lists/*;
