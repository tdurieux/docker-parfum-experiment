# Image used  a init container
FROM k8spatterns/gomplate
#FROM busybox
USER 1000
#CMD ls -laR /params && id && cat /params/config.yml