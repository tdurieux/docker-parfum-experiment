FROM fedora:latest

RUN yum -y install mesa-libGL && yum clean all && rm -rf /var/cache/yum

COPY *.AppImage .
RUN ./*.AppImage --appimage-extract-and-run --version

RUN LD_DEBUG_APP=true ./*.AppImage --appimage-extract-and-run --version
