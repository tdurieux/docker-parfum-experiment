FROM fedora:29
ADD . /root
RUN dnf install -y 'dnf-command(config-manager)'
RUN dnf config-manager --add-repo https://download.opensuse.org/repositories/home:hpcoder1/Fedora_29/home:hpcoder1.repo
RUN dnf install -y xorg-x11-server-Xvfb scidavis
RUN sh /root/scidavisSmoke.sh
