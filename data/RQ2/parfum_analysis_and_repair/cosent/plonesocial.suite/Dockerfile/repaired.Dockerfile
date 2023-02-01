from ubuntu:14.04.2
maintainer guido.stevens@cosent.net
run apt-get update
run apt-get install --no-install-recommends -y python-dev gcc make zlib1g-dev libjpeg-dev python-virtualenv git-core && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y libfreetype6-dev gettext python-pip libxslt1-dev python-lxml && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y jed firefox xvfb && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y python-tk && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y python-gdbm && rm -rf /var/lib/apt/lists/*;
run useradd -m -d /app app
run echo plonesocial.suite > /etc/debian_chroot
cmd ["/bin/bash"]
