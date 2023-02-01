FROM fedora:32

RUN dnf -y update && dnf clean all
RUN dnf -y --setopt=install_weak_deps=False --best install \
	ansible \
	nmap-ncat \
	openssh-clients \
	python3 \
	python3-CacheControl \
	python3-cloudpickle \
	python3-colorama \
	python3-fasteners \
	python3-inotify_simple \
	python3-lockfile \
	python3-paramiko \
	python3-pexpect \
	python3-pyxdg \
	python3-requests \
	python3-requests-mock \
	python3-rangehttpserver \
	python3-GitPython \
	qemu-img \
	qemu-kvm-core \
	&& dnf clean all

RUN mkdir -p /user-home/.cache/fingertip /containerized-fingertip /cwd
ENV HOME /user-home
RUN chmod -R 777 /user-home /cwd
WORKDIR /cwd
