ARG registry
FROM $registry/labtainer.network
LABEL description="This is base Docker image for Labtainer Wine installations"
RUN mv /var/tmp/sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common apt-transport-https && rm -rf /var/lib/apt/lists/*;
# restore original apt-sources to get i386 packages
RUN mv /var/tmp/sources.list /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN wget -nc https://dl.winehq.org/wine-builds/Release.key
RUN apt-key add Release.key
RUN apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN apt-get update
RUN apt-get install -y --install-recommends winehq-stable
RUN systemd-machine-id-setup
RUN mv /etc/apt/sources.list /var/tmp/
ADD system/var/tmp/wine-mono-4.7.1.msi /var/tmp/wine-mono-4.7.1.msi
ADD system/etc/nps.sources.list /etc/apt/sources.list
