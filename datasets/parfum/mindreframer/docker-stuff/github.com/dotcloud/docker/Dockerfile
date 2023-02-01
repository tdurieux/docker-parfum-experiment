# This file describes the standard way to build Docker, using docker
#
# Usage:
#
# # Assemble the full dev environment. This is slow the first time.
# docker build -t docker .
# # Apparmor messes with privileged mode: disable it
# /etc/init.d/apparmor stop ; /etc/init.d/apparmor teardown
#
# # Mount your source in an interactive container for quick testing:
# docker run -v `pwd`:/go/src/github.com/dotcloud/docker -privileged -lxc-conf=lxc.aa_profile=unconfined -i -t docker bash
#
#
# # Run the test suite:
# docker run -privileged -lxc-conf=lxc.aa_profile=unconfined docker go test -v
#
# # Publish a release:
# docker run -privileged -lxc-conf=lxc.aa_profile=unconfined \
# -e AWS_S3_BUCKET=baz \
# -e AWS_ACCESS_KEY=foo \
# -e AWS_SECRET_KEY=bar \
# -e GPG_PASSPHRASE=gloubiboulga \
# -lxc-conf=lxc.aa_profile=unconfined -privileged docker hack/release.sh
# 

docker-version 0.6.1
from	ubuntu:12.04
maintainer	Solomon Hykes <solomon@dotcloud.com>
# Build dependencies
run	echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list
run	apt-get update
run	apt-get install -y -q curl
run	apt-get install -y -q git
run	apt-get install -y -q mercurial
# Install Go
run	curl -s https://go.googlecode.com/files/go1.1.2.linux-amd64.tar.gz | tar -v -C /usr/local -xz
env	PATH	/usr/local/go/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
env	GOPATH	/go:/go/src/github.com/dotcloud/docker/vendor
env	CGO_ENABLED 0
run	cd /tmp && echo 'package main' > t.go && go test -a -i -v
# Ubuntu stuff
run	apt-get install -y -q ruby1.9.3 rubygems libffi-dev
run	gem install fpm
run	apt-get install -y -q reprepro dpkg-sig
# Install s3cmd 1.0.1 (earlier versions don't support env variables in the config)
run	apt-get install -y -q python-pip
run	pip install s3cmd
run	pip install python-magic
run	/bin/echo -e '[default]\naccess_key=$AWS_ACCESS_KEY\nsecret_key=$AWS_SECRET_KEY\n' > /.s3cfg
# Runtime dependencies
run	apt-get install -y -q iptables
run	apt-get install -y -q lxc
volume	/var/lib/docker
workdir	/go/src/github.com/dotcloud/docker
# Wrap all commands in the "docker-in-docker" script to allow nested containers
entrypoint ["hack/dind"]
# Upload docker source
add	.       /go/src/github.com/dotcloud/docker
