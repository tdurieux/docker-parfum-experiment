FROM robocupssl/ubuntu-vnc:0.3.1

USER root

RUN set -xe; \
	apt-get update; \
	apt-get install --no-install-recommends -y \
		libprotobuf-dev qtbase5-dev libqt5opengl5-dev libusb-1.0-0-dev libsdl2-dev libqt5svg5-dev \
		cmake g++ protobuf-compiler ninja-build make ccache lld patch gdb valgrind \
		git git-lfs python2 xz-utils python3 python-is-python2 \
		ca-certificates curl gnupg apt-transport-https \
		luarocks neovim firefox; \
	# Setup NodeJS repo \
	curl -f --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - 2>/dev/null; \
	echo 'deb https://deb.nodesource.com/node_12.x focal main' > /etc/apt/sources.list.d/nodesource.list; \
	echo 'deb-src https://deb.nodesource.com/node_12.x focal main' >> /etc/apt/sources.list.d/nodesource.list; \
	# Setup Microsoft repo for VS Code \
	curl -f --silent https://packages.microsoft.com/keys/microsoft.asc | apt-key add 2>/dev/null; \
	echo 'deb https://packages.microsoft.com/repos/code stable main' >> /etc/apt/sources.list.d/microsoft.list; \
	# Setup repo for Sublime Text 3 \
	curl -f --silent https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add - 2>/dev/null; \
	echo "deb https://download.sublimetext.com/ apt/stable/" >> /etc/apt/sources.list.d/sublime-text.list; \
	# Install NodeJS and VS Code \
	apt-get update; \
	apt-get install -y --no-install-recommends nodejs code sublime-text; \
	# Setup Linters \
	npm install -g tslint@6.1.1 typescript@3.8.3; npm cache clean --force; \
	luarocks install luacheck; \
	# Cleanup apt \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
	# Fix permissions \
	chown --recursive default:default ~default/.cache; \
	chown --recursive default:default ~default/.config;

USER default
