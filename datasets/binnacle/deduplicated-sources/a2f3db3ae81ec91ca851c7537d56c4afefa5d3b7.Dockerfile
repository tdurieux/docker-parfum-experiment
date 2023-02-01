FROM ubuntu:18.04

# Username is assumed to be 'duktape' for now, change only UID/GID if required.
ARG USERNAME=duktape
ARG UID=1000
ARG GID=1000

# Set timezone to Europe/Helsinki, some tests depend on it.  Must be done
# first to avoid interactive prompts in tzdata install.
RUN echo "=== Timezone setup ===" && \
	echo "Europe/Helsinki" > /etc/timezone && \
	ln -s /usr/share/zoneinfo/Europe/Helsinki /etc/localtime

# Node.js and packages.  This set should cover everything necessary to build
# Duktape, the duktape.org website, run tests, etc.
RUN echo "=== Node.js and package install ===" && \
	apt-get update && apt-get install -qy curl && \
	curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
	dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -qy \
		build-essential llvm valgrind libc6-dbg libc6-dbg:i386 \
		gcc gcc-multilib g++-multilib gcc-4.8 gcc-5 gcc-6 \
		clang clang-tools clang-3.9 clang-4.0 clang-5.0 clang-6.0 clang-7 \
		libncurses5-dev libncurses5 \
		python python-yaml make tig git bc ant diffstat colordiff nodejs \
		python-bs4 tidy wget curl source-highlight rst2pdf openjdk-11-jre \
		zip unzip genisoimage vim w3m screen tzdata cdecl

# Add non-root uid/gid to image, replicating host uid/gid if possible.
# Setup the /home/$USERNAME user with some convenience stuff like a .gitconfig,
# replicating the host setup if possible.  Also set prompts so that it's easy
# to see when we're running inside a container.
#
# https://stackoverflow.com/questions/44683119/dockerfile-replicate-the-host-user-uid-and-gid-to-the-image
RUN echo "=== User setup, /work directory creation ===" && \
	groupadd -g $GID -o $USERNAME && \
	useradd -m -u $UID -g $GID -o -s /bin/bash $USERNAME && \
	mkdir /work && chown $UID:$GID /work && chmod 755 /work && \
	echo "PS1='\033[40;37mDOCKER\033[0;34m \u@\h [\w] >>>\033[0m '" > /root/.profile && \
	echo "PS1='\033[40;37mDOCKER\033[0;34m \u@\h [\w] >>>\033[0m '" > /home/$USERNAME/.profile && \
	chown $UID:$GID /home/$USERNAME/.profile
COPY --chown=duktape:duktape gitconfig /home/$USERNAME/.gitconfig
RUN chmod 644 /home/$USERNAME/.gitconfig

# Switch to non-root user.  (Note that COPY will still copy files as root,
# so use COPY --chown for files copied.)
#RUN echo "WHOAMI: `whoami`, UID: `id -u`, GID: `id -g`, HOME: $HOME"
USER $USERNAME
#RUN echo "WHOAMI: `whoami`, UID: `id -u`, GID: `id -g`, HOME: $HOME"

# Use /work for builds, temporaries, etc.
WORKDIR /work

# Shared script for setting up the duktape/ directory.
COPY --chown=duktape:duktape prepare_repo.sh .
RUN chmod 755 prepare_repo.sh

# Emscripten.  Source emsdk-portable/emsdk_env.sh to get 'emcc' into PATH.
RUN echo "=== Emscripten ===" && \
	wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz && \
	tar xvfz emsdk-portable.tar.gz && \
	cd emsdk-portable && \
	./emsdk update && \
	./emsdk install latest && \
	./emsdk activate latest && \
	cd .. && \
	rm emsdk-portable.tar.gz

# Clone some useful repositories into 'repo-snapshots' to reduce network
# traffic.  Derived images can then just 'git pull' to get them up to date.
RUN echo "=== Repo snapshots ===" && \
	mkdir /work/repo-snapshots && \
	git clone https://github.com/svaarala/duktape.git repo-snapshots/duktape && \
	git clone https://github.com/svaarala/duktape-wiki.git repo-snapshots/duktape-wiki && \
	git clone https://github.com/svaarala/duktape-releases.git repo-snapshots/duktape-releases

# /work/duktape-prep is prepared to be close to master in case the derived
# image needs master.  Copy it from the repo snapshot, but leave the snapshot
# intact.  Try to minimize network traffic by pulling in some dependencies into
# the image.
RUN echo "=== Prepare duktape-prep repo ===" && \
	cp -r repo-snapshots/duktape duktape-prep && \
	cp -r repo-snapshots/duktape-releases duktape-prep/duktape-releases && \
	cd duktape-prep && \
	make runtestsdeps linenoise UglifyJS2 && \
	make duktape-releases lz-string jquery-1.11.2.js && \
	make emscripten && emscripten/emcc -s WASM=0 -o /tmp/test_mandel2.js misc/test_mandel2.c && ls -l /tmp/test_mandel2.js && rm /tmp/test_mandel2.* && \
	make luajs underscore lodash bluebird.js closure-compiler && \
	make clean

# Dump some versions.
RUN echo "=== Versions ===" && \
	echo "GCC:" && gcc -v && \
	echo "CLANG:" && clang -v && \
	bash -c 'echo "EMCC:" && . emsdk-portable/emsdk_env.sh && emcc -v'
