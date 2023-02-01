FROM fedora:35
MAINTAINER Tobias Junghans <tobydox@veyon.io>

RUN \
	dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-35.noarch.rpm && \
	dnf install -y --setopt=install_weak_deps=False \
		git gcc-c++ ninja-build cmake rpm-build fakeroot fakeroot-libs \
		qt5-qtbase-devel qt5-qtbase-private-devel qt5-qtbase qt5-linguist qt5-qttools qt5-qtquickcontrols2-devel qt5-qtwebengine-devel \
		libXtst-devel libXrandr-devel libXinerama-devel libXcursor-devel libXrandr-devel libXdamage-devel libXcomposite-devel libXfixes-devel \
		libfakekey-devel \
		libjpeg-turbo-devel zlib-devel libpng-devel lzo-devel \
		libvncserver-devel \
		openssl-devel \
		pam-devel \
		procps-devel \
		qca-qt5-devel qca-qt5-ossl \
		ffmpeg-devel \
		cyrus-sasl-devel \
		openldap-devel
