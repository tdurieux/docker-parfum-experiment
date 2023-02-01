FROM opensuse/leap:15.3
ARG project=minsky
ADD . /root
RUN zypper addrepo https://download.opensuse.org/repositories/home:hpcoder1/openSUSE_Leap_15.3/home:hpcoder1.repo
RUN zypper --gpg-auto-import-keys refresh
RUN zypper --non-interactive install $project
RUN minsky /root/smoke.tcl