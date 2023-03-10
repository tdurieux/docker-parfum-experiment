--- git/docker/amd64/Dockerfile	2021-02-12 11:45:13.762372371 +0100
+++ Dockerfile	2021-02-12 11:59:56.727518522 +0100
@@ -111,3 +111,23 @@
 WORKDIR /
 ENTRYPOINT ["/usr/bin/dumb-init", "--"]
 CMD ["/start.sh"]
+
+####################### dpkg target ##########################
+FROM build as dpkg
+RUN mkdir /outdir
+RUN mkdir -p /vaultwarden_package/DEBIAN
+RUN mkdir -p /vaultwarden_package/usr/local/bin
+RUN mkdir -p /vaultwarden_package/usr/lib/systemd/system
+RUN mkdir -p /vaultwarden_package/etc/@@PACKAGEDIR@@
+RUN mkdir -p /vaultwarden_package/usr/share/@@PACKAGEDIR@@
+
+WORKDIR /vaultwarden_package
+COPY debian/control /vaultwarden_package/DEBIAN/control
+COPY debian/postinst /vaultwarden_package/DEBIAN/postinst
+COPY debian/conffiles /vaultwarden_package/DEBIAN/conffiles
+COPY debian/config.env /vaultwarden_package/etc/@@PACKAGEDIR@@
+COPY debian/@@EXECUTABLENAME@@.service /vaultwarden_package/usr/lib/systemd/system
+COPY --from=vault /web-vault /vaultwarden_package/usr/share/@@PACKAGEDIR@@/web-vault
+COPY --from=build app/target/release/vaultwarden /vaultwarden_package/usr/local/bin/@@EXECUTABLENAME@@
+
+RUN dpkg-deb --build . /outdir/@@PACKAGEDIR@@.deb