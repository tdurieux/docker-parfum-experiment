FROM debian:stretch-slim

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Get all packages, install Java OpenJDK 11 and create a user

RUN echo 'Installing SEPIA-Home...' && \
#
#	Add Debian backports
	echo 'deb http://ftp.debian.org/debian stretch-backports main' | tee /etc/apt/sources.list.d/stretch-backports.list &&\
#
#	Update packages
	apt-get update && \
#
#	Fix for Debian9 slim to be able to install Java
	mkdir -p /usr/share/man/man1 &&\
#
#	Get packages
	apt-get install -y --no-install-recommends \
        git wget curl nano unzip zip procps \
		openjdk-11-jdk-headless ca-certificates-java maven && \
#
#   Clean up
    apt-get clean && apt-get autoclean && apt-get autoremove -y && \
#
#   Create a Linux user
    useradd --create-home --shell /bin/bash admin && \
	adduser admin sudo && rm -rf /var/lib/apt/lists/*;

# Set JAVA_HOME path ... just in case

ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
ENV PATH="${JAVA_HOME}:${PATH}"

# Build SEPIA-Home (custom-bundle, single-server, SBC version)

USER admin

RUN echo "Building SEPIA-Home (custom bundle) ..." && \
#
#	Make target and temporary folder (SEPIA should be in ~/SEPIA !!)
	mkdir -p ~/SEPIA/tmp && \
	cd ~/SEPIA/tmp && \
#
#	Download files
	wget -O sepia-custom-bundle-folder.zip https://github.com/SEPIA-Framework/sepia-installation-and-setup/blob/master/sepia-custom-bundle-folder.zip?raw=true && \
	unzip -n sepia-custom-bundle-folder.zip -d ~/SEPIA && \
#
	git clone https://github.com/SEPIA-Framework/sepia-core-tools-java.git && \
	git clone https://github.com/SEPIA-Framework/sepia-websocket-server-java.git && \
	git clone https://github.com/SEPIA-Framework/sepia-assist-server.git && \
	git clone https://github.com/SEPIA-Framework/sepia-teach-server.git && \
	git clone https://github.com/SEPIA-Framework/sepia-reverse-proxy.git && \
	git clone https://github.com/SEPIA-Framework/sepia-mesh-nodes.git && \
	git clone https://github.com/SEPIA-Framework/sepia-html-client-app.git && \
	git clone https://github.com/SEPIA-Framework/sepia-admin-tools.git && \
#
#	Build all modules and copy client and admin-tools
	cd sepia-core-tools-java && mvn install && cp -r target/release/. ~/SEPIA/sepia-assist-server/ && cd .. && \
	cd sepia-websocket-server-java && mvn install && cp -r target/release/. ~/SEPIA/sepia-websocket-server-java/ && cd .. && \
	cd sepia-assist-server && mvn install && cp -r target/release/. ~/SEPIA/sepia-assist-server/ && cd .. && \
	cd sepia-teach-server && mvn install && cp -r target/release/. ~/SEPIA/sepia-teach-server/ && cd .. && \
	cd sepia-reverse-proxy && mvn install && cp -r target/release/. ~/SEPIA/sepia-reverse-proxy/ && cd .. && \
	cd sepia-mesh-nodes/java && mvn install && cp -r target/release/. ~/SEPIA/sepia-mesh-nodes/ && cd ../.. && \
	mkdir -p sepia-assist-server/Xtensions/WebContent/app && \
	cp -r sepia-html-client-app/www/. ~/SEPIA/sepia-assist-server/Xtensions/WebContent/app/ && \
	mkdir -p sepia-assist-server/Xtensions/WebContent/tools && \
	cp -r sepia-admin-tools/admin-web-tools/. ~/SEPIA/sepia-assist-server/Xtensions/WebContent/tools/ && \
#
#	Download and unzip elasticsearch (keeping the existing config folder)
	wget -O elasticsearch.zip https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.3.zip && \
	unzip -n elasticsearch.zip && \
	cp -rn elasticsearch-*/. ~/SEPIA/elasticsearch/ && \
#
#	Clean up
	cd ~/SEPIA && \
	find . -iname "*.sh" -exec chmod +x {} \; && \
	rm -r ~/SEPIA/tmp
	# we could also remove maven here and maybe some other packages
#
#	Setup SEPIA
#	NOTE: This has to be done (e.g. by sharing external config folder) before server can run without error
#	e.g.:
#	0 - Create shared folder:				export SEPIA_SHARE=/home/[my-user]/sepia-share && mkdir -p $SEPIA_SHARE
#	1 - Copy SEPIA folder from container:	sudo docker run --rm --name=sepia_home -p 20726:20726 -it -v $SEPIA_SHARE:/home/admin/sepia-backup sepia/home:test cp -r /home/admin/SEPIA /home/admin/sepia-backup
#	2 - Run setup with shared folder:		sudo docker run --rm --name=sepia_home -p 20726:20726 -it -v $SEPIA_SHARE/SEPIA:/home/admin/SEPIA sepia/home:test bash setup.sh
#	3 - Run server:							sudo docker run --rm --name=sepia_home -p 20726:20726 -d -v $SEPIA_SHARE/SEPIA:/home/admin/SEPIA sepia/home:test
# TODO: replace SEPIA proxy with Nginx

# Start
WORKDIR /home/admin/SEPIA
CMD bash on-docker.sh
