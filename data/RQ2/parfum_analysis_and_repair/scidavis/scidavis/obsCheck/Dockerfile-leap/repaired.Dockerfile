FROM opensuse/leap:15
ARG project=scidavis
ADD . /root
RUN zypper addrepo https://download.opensuse.org/repositories/home:hpcoder1/openSUSE_Leap_15.3/home:hpcoder1.repo
RUN zypper --gpg-auto-import-keys refresh
RUN zypper --non-interactive install xorg-x11-server $project
RUN sh /root/scidavisSmoke.sh