FROM archlinux
MAINTAINER Peter Bartfai pbartfai@stardust.hu

ADD install-devel-packages.sh /
RUN ./install-devel-packages.sh
VOLUME /mnt/lego
CMD cd ldview/QT ; \
	git pull;  \
	chmod o+w -R .. ;\
	sudo -u nobody makepkg -ef ;\
	sed -i 's/qmake /qmake6 /g' PKGBUILD                    ;\
	sed -i 's/lrelease /lrelease6 /g' PKGBUILD              ;\
	sed -i '/pkgname/s/ldview.*osmesa/ldview-qt6/' PKGBUILD ;\
	sed -i '/^depends/s/)/ '\''qt6-5compat'\'')/' PKGBUILD  ;\
	sed -i 's/ldview(/ldview-qt6(/' PKGBUILD                ;\
	sudo -u nobody makepkg -ef ;\
	git checkout -- PKGBUILD ;\
	cp -f ldview*pkg.tar.* /mnt/lego