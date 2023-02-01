FROM opensuse/tumbleweed:latest
MAINTAINER Tobias Junghans <tobydox@veyon.io>

RUN \
	zypper --gpg-auto-import-keys install -y git gcc-c++ ninja cmake rpm-build fakeroot \
		qt6-widgets-devel qt6-widgets-private-devel qt6-concurrent-devel qt6-linguist-devel qt6-tools-devel qt6-quickcontrols2-devel qt6-webenginewidgets-devel \
		libXtst-devel libXrandr-devel libXinerama-devel libXcursor-devel libXrandr-devel libXdamage-devel libXcomposite-devel libXfixes-devel \
		libfakekey-devel \
		libjpeg8-devel \
		zlib-devel \
		libpng16-devel libpng16-compat-devel \
		libopenssl-devel \
		procps-devel \
		pam-devel lzo-devel \
		qca-qt6-devel qca-qt6-plugins \
		libavcodec-devel libavformat-devel libavutil-devel libswscale-devel \
		cyrus-sasl-devel \
		openldap2-devel

