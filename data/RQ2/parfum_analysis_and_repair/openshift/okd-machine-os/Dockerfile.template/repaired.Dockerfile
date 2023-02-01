FROM INITIAL_IMAGE as oscontainer
FROM scratch
COPY --from=oscontainer /srv/ /srv/
COPY --from=oscontainer /extensions/ /extensions/
COPY manifests/ /manifests/
COPY bootstrap/ /bootstrap/
LABEL io.openshift.release.operator=true \
      io.openshift.build.version-display-names="machine-os=Fedora CoreOS" \
      io.openshift.build.versions="machine-os=412.36.0"
ENTRYPOINT ["/noentry"]