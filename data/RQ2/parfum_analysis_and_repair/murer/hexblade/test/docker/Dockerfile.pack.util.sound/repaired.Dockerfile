FROM hexblade/hexblade-base:dev
COPY src/pack/util/sound.sh /opt/hexblade/src/pack/util/sound.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/sound.sh pavucontrol

FROM hexblade/hexblade-base:dev
COPY src/pack/util/sound.sh /opt/hexblade/src/pack/util/sound.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/sound.sh pulseaudio