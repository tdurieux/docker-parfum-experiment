##
# gregtzar/tomb
#
# This creates an Ubuntu derived base image and installs the tomb libarary
# along with it's dependencies.

FROM dyne/devuan:chimaera

ARG DEBIAN_FRONTEND=noninteractive
ARG TOMB_VERSION=2.9

# Install dependencies
RUN apt-get update -y && \
	apt-get install -y -q --no-install-recommends\
	make \
	sudo \
	curl \
	rsync \
	zsh \
	gnupg \
	cryptsetup \
	pinentry pinentry-curses \
	file xxd \
	steghide \
	mlocate \
	swish-e && rm -rf /var/lib/apt/lists/*;

# Build and install Tomb from remote repo
RUN curl -f https://files.dyne.org/tomb/releases/Tomb-$TOMB_VERSION.tar.gz -o /tmp/Tomb-$TOMB_VERSION.tar.gz && \
	cd /tmp && \
	tar -zxvf /tmp/Tomb-$TOMB_VERSION.tar.gz && \
	cd /tmp/Tomb-$TOMB_VERSION && \
	make install && rm /tmp/Tomb-$TOMB_VERSION.tar.gz
