FROM mageia:6
MAINTAINER Peter Bartfai pbartfai@stardust.hu

ADD install-devel-packages.sh /
RUN ./install-devel-packages.sh

VOLUME /mnt/lego
ENV PATH /usr/lib64/qt4/bin:$PATH
CMD cd ldview/QT ; \
	git pull; \
	PATH=/usr/lib64/qt5/bin:$PATH ;\
	export PATH ;\
	./makerpm