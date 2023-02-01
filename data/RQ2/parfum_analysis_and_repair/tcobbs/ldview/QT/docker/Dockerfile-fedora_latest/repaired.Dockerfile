FROM fedora:latest
MAINTAINER Peter Bartfai pbartfai@stardust.hu

ADD install-devel-packages.sh /
RUN ./install-devel-packages.sh -noqt6

VOLUME /mnt/lego
CMD dnf update -x kernel* -y; \
	cd ldview/QT ; \
	git pull; \
	mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} ;\
	./makerpm