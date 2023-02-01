FROM ubuntu:16.04

RUN apt-get update && apt-get -y --no-install-recommends install sudo apt-transport-https devscripts git wget vim net-tools && rm -rf /var/lib/apt/lists/*;
ADD 01-add-single-file.patch /root
ADD 02-fix-nohuge-option.patch /root
ADD virtio-user.patch /root
ADD build_vpp.sh  /root
ADD setup_vpp.sh  /root
ADD startup.conf /root
ADD setup_virtio_user.sh /root
RUN /root/build_vpp.sh
