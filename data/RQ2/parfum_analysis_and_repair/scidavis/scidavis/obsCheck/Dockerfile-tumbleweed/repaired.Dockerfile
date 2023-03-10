FROM opensuse/tumbleweed
ARG project=scidavis
ADD . /root
RUN zypper addrepo https://download.opensuse.org/repositories/home:hpcoder1/openSUSE_Tumbleweed/home:hpcoder1.repo
RUN zypper --gpg-auto-import-keys refresh
RUN zypper --non-interactive install xorg-x11-server $project
RUN sh /root/scidavisSmoke.sh