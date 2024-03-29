ARG registry
FROM $registry/labtainer.network
LABEL description="This is base Docker image for Labtainer network components with wireshark"
# restore original apt-sources to unwind use of NPS mirror
RUN mv /var/tmp/sources.list /etc/apt/sources.list
RUN echo 'wireshark-common        wireshark-common/install-setuid boolean true' | debconf-set-selections
RUN apt-get update && apt-get install -y --no-install-recommends wireshark && rm -rf /var/lib/apt/lists/*;
RUN chmod a+x /usr/bin/dumpcap
# modified to create new instance
RUN systemd-machine-id-setup

