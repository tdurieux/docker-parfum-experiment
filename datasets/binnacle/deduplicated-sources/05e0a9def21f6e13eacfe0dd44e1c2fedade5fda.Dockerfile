FROM alanfranz/fpm-within-docker:fedora-27
MAINTAINER Alan Franzoni <username@franzoni.eu>
RUN dnf clean metadata && dnf -y install python wget ca-certificates
