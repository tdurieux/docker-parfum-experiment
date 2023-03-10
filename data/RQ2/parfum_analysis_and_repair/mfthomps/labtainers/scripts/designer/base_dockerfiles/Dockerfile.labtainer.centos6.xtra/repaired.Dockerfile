ARG registry
FROM $registry/labtainer.centos6
LABEL description="This is extended base Docker image for Labtainer CENTOS 6 images"
RUN yum install -y e2fsprogs libtool-ltdl libudev selinux-policy libaio libXdmcp libXtst mesa-dri-drivers xkeyboard-config xorg-x11-xauth xorg-x11-xkb-utils cups && rm -rf /var/cache/yum
