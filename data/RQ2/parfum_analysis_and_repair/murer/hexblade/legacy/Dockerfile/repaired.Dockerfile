FROM ubuntu:20.04

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install x11vnc && rm -rf /var/lib/apt/lists/*;

ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -r supersudo && \
  echo "%supersudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/supersudo && \
  useradd -u 1000 -m -G adm,cdrom,sudo,supersudo,dip,plugdev -s /bin/bash hexblade

RUN mkdir -p /opt/hexblade/packages

USER hexblade
ENV HOME /home/hexblade
ENV USER hexblade
WORKDIR /home/hexblade

COPY packages/tools /opt/hexblade/packages/tools
RUN sudo -E /opt/hexblade/packages/tools/tools.sh install

COPY packages/graphics /opt/hexblade/packages/graphics
RUN sudo -E /opt/hexblade/packages/graphics/graphics.sh xterm
RUN sudo -E /opt/hexblade/packages/graphics/graphics.sh mousepad

COPY packages/lxterminal /opt/hexblade/packages/lxterminal
RUN sudo -E /opt/hexblade/packages/lxterminal/lxterminal.sh install

COPY packages/openbox /opt/hexblade/packages/openbox
RUN sudo -E /opt/hexblade/packages/openbox/openbox.sh install
RUN sudo -E /opt/hexblade/packages/openbox/openbox.sh lockscreen disable

COPY . /opt/hexblade
RUN sudo cp -Rv /opt/hexblade/docker/etc/xdg /etc

ENV DISPLAY :99
EXPOSE 5900

ENV DEBIAN_FRONTEND=

CMD "/opt/hexblade/docker/entrypoint.sh"
