FROM hexblade/hexblade-base:dev
COPY src/pack/util/graphics.sh /opt/hexblade/src/pack/util/graphics.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh firefox
COPY . /opt/hexblade