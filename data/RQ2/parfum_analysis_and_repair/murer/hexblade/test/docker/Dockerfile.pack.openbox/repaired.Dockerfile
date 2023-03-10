FROM hexblade/hexblade-base:dev

COPY src/pack/openbox /opt/hexblade/src/pack/openbox
RUN sudo -E /opt/hexblade/src/pack/openbox/openbox.sh install
RUN sudo -E /opt/hexblade/src/pack/openbox/openbox.sh extra
RUN sudo -E /opt/hexblade/src/pack/openbox/openbox.sh lockscreen enable
RUN sudo -E /opt/hexblade/src/pack/openbox/openbox.sh lockscreen disable
RUN sudo -E /opt/hexblade/src/pack/openbox/openbox.sh xinit
RUN sudo -E /opt/hexblade/src/pack/openbox/openbox.sh background 333333
RUN sudo -E /opt/hexblade/src/pack/openbox/openbox.sh xhost_user hexblade