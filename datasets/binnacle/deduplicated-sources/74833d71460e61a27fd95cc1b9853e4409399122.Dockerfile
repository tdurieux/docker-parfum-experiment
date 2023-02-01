FROM debian:stretch

# The add is before the RUN to ensure we get the latest version of packages
# Docker will cache RUN commands, but because the SHA1 of the dir will be
# different it will not cache this layer
ADD . /tmp/ironic-python-agent

# Copy the proxy.sh script which copies the proxy settings from the host
# environment (if they are set). This file will be dynamically created by
# imagebuild/coreos/docker_build.bash
# TODO(jlvilla): Once Docker 1.9 is widely deployed, switch to using the 'ARG'
# command which was added in Docker 1.9. Currently Ubuntu 14.04 uses Docker
# 1.6. Using the ARG command will be a much cleaner solution.
COPY proxy.sh /usr/bin/proxy.sh

# Ensure we hit a single mirror for builds, since httpredir is flakey
RUN sed -i 's/httpredir/http.us/g' /etc/apt/sources.list

# Install requirements: Python for ironic-python-agent, others for putting an
# image on disk
RUN proxy.sh apt-get update && \
    proxy.sh apt-get -y upgrade && \
    proxy.sh apt-get install -y --no-install-recommends netbase gdisk \
        python2.7 python2.7-dev python-pip qemu-utils parted hdparm \
        util-linux genisoimage git gcc bash coreutils tgt dmidecode \
        ipmitool psmisc dosfstools bsdmainutils open-iscsi udev \
        smartmontools iptables lshw mdadm

# Some cleanup
RUN proxy.sh apt-get -y autoremove && \
    proxy.sh apt-get clean

# Before cleaning mark packages that are required so they are not removed
RUN apt-mark manual python-setuptools
RUN apt-mark manual python-minimal

# Install requirements separately, because pip understands a git+https url
# while setuptools doesn't
RUN proxy.sh pip install --upgrade pip setuptools
RUN proxy.sh pip install -c /tmp/ironic-python-agent/upper-constraints.txt --no-cache-dir -r /tmp/ironic-python-agent/requirements.txt

# This will succeed because all the dependencies were installed previously
RUN proxy.sh pip install -c /tmp/ironic-python-agent/upper-constraints.txt --no-cache-dir /tmp/ironic-python-agent

# Remove no longer needed packages
# NOTE(jroll) leave git to avoid strange apt issues in downstream Dockerfiles
# that may inherit from this one.
RUN proxy.sh apt-get -y purge gcc-4.6 gcc python2.7-dev && \
    proxy.sh apt-get -y autoremove && \
    proxy.sh apt-get clean
RUN rm -rf /tmp/ironic-python-agent
RUN rm -rf /var/lib/apt/lists/*

# Remove metadata_csum option when creating filesystems
# since cirros doesn't support it.
# This option was added in Debian stretch as default.
RUN sed -i 's/,metadata_csum//g' /etc/mke2fs.conf

CMD [ "/usr/local/bin/ironic-python-agent" ]
