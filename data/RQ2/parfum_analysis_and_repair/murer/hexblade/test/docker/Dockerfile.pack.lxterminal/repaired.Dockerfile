FROM hexblade/hexblade-base:dev

COPY src/pack/lxterminal /opt/hexblade/src/pack/lxterminal
RUN sudo -E /opt/hexblade/src/pack/lxterminal/lxterminal.sh install