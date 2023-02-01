# ===========================================================================================
# Dockerfile for building OpenWrt
#
# References:
#	http://wiki.openwrt.org/doc/howto/buildroot.exigence
# ===========================================================================================

FROM gmacario/easy-build

MAINTAINER Gianpaolo Macario, gmacario@gmail.com

# Make sure the package repository is up to date
RUN apt-get update
RUN apt-get -y upgrade

# Install packages we cannot leave without...
RUN apt-get install --no-install-recommends -y git tig && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y mc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
# Make sure the directory exists, otherwise sshd will not start
RUN mkdir -p /var/run/sshd
RUN apt-get install --no-install-recommends -y screen && rm -rf /var/lib/apt/lists/*;

# Install prerequisite packages for OpenWrt BuildRoot
RUN apt-get -y --no-install-recommends install git-core build-essential libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install subversion && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libncurses5-dev gawk python wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libxml-parser-perl && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /shared

# NOTE: Uncomment if user "build" is not already created inside the base image
## Create non-root user that will perform the build of the images
#RUN useradd --shell /bin/bash build
#RUN mkdir -p /home/build
#RUN chown -R build /home/build

# 2. Download the OpenWrt bleeding edge with git
RUN su -c "cd ~ && git clone git://git.openwrt.org/openwrt.git" build

# 3. (optional) Download and install all available "feeds"
RUN su -c "cd ~/openwrt && ./scripts/feeds update -a" build
RUN su -c "cd ~/openwrt && ./scripts/feeds install -a" build

# 4. Make OpenWrt Buildroot check for missing packages on your build-system
RUN su -c "cd ~/openwrt make defconfig" build
RUN su -c "cd ~/openwrt make prereq" build

# 5. Add build.local/ to container
ADD build.local /home/build
#RUN su -c "" build

ENTRYPOINT ["/bin/bash"]

# Expose sshd port
EXPOSE 22

# EOF
