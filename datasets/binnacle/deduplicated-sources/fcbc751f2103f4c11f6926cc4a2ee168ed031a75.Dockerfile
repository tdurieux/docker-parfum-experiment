FROM fedora:30
MAINTAINER Peter Bartfai pbartfai@stardust.hu

RUN dnf install -y git rpmlint ccache dnf-plugins-core rpm-build
RUN git clone https://github.com/tcobbs/ldview
RUN dnf builddep -y ldview/QT/LDView.spec
RUN cd ldview/QT ; \
	cp -f LDView.spec LDView-qt5.spec ;\
	sed 's/define qt5 0/define qt5 1/' -i LDView-qt5.spec ;\
	dnf builddep -y LDView-qt5.spec
#"dnf builddep" fails with setarch
#RUN setarch i686 dnf builddep -y --best ldview/QT/LDView.spec
#RUN dnf -y install qt-devel.i686 zlib-devel.i686 libpng-devel.i686 \
#	mesa-libOSMesa-devel.i686 glibc-devel.i686 \
#	libjpeg-turbo-devel.i686 gl2ps-devel.i686 tinyxml-devel.i686 \
#	mesa-libGLU-devel.i686 libglvnd-devel.i686 \
#	cmake.i686 libX11-devel.i686 openssl-devel.i686

VOLUME /mnt/lego
CMD dnf update -x kernel* -y; \
	cd ldview/QT ; \
	git pull; \
	rpmbuild -bb LDView.spec ; \
	cp -f LDView.spec LDView-qt5.spec ;\
	sed 's/define qt5 0/define qt5 1/' -i LDView-qt5.spec ;\
	rpmbuild -bb LDView-qt5.spec ;\
#	export LDVDEV32=YES ;\
#	rpmbuild --target=i686 -bb LDView.spec ; \
	for r in /root/rpm*/RPMS/*/ldview*.rpm /usr/src/redhat/RPMS/*/ldview*.rpm /usr/src/packages/RPMS/*/ldview*.rpm ; do \
		if [ -f $r ] ; then \
			if [ -d /mnt/lego ] ; then \
				cp -f $r /mnt/lego ; \
			fi ; \
			rpmlint $r ; \
		fi; \
	done
