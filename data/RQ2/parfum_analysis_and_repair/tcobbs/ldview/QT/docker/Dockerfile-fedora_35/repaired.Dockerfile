FROM fedora:35
MAINTAINER Peter Bartfai pbartfai@stardust.hu

ADD install-devel-packages.sh /
RUN ./install-devel-packages.sh

VOLUME /mnt/lego
CMD dnf update -x kernel* -y; \
	cd ldview/QT ; \
	git pull; \
	mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} ;\
	./makerpm