FROM hexblade/hexblade-base:dev

COPY src/pack/util/graphics.sh /opt/hexblade/src/pack/util/graphics.sh

RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh xterm
RUN xterm -v

RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh mousepad
RUN mousepad --help

RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh xfce4_screenshooter
RUN xfce4-screenshooter --help

RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh pcmanfm
RUN pcmanfm --help

RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh firefox
RUN firefox --version

RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh network_manager_gnome
RUN nmcli --version

RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh thunar
RUN thunar --help

RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh ubiquity
RUN ls -lart /usr/bin/ubiquity 