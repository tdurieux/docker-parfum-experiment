diff --git a/Dockerfile b/Dockerfile.local
index 3a538899..01197257 100644
--- a/Dockerfile
+++ b/Dockerfile.local
@@ -1,6 +1,5 @@
 ### This is a generated file from Dockerfile.in ###
-#@follow_tag(openshift-golang-builder:1.14)
-FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.16-openshift-4.8 AS builder
+FROM registry.ci.openshift.org/openshift/release:golang-1.16 as builder
 ENV BUILD_VERSION=${CI_CONTAINER_VERSION}
 ENV OS_GIT_MAJOR=${CI_X_VERSION}
 ENV OS_GIT_MINOR=${CI_Y_VERSION}
 RUN make build
 
 
-#@follow_tag(openshift-ose-cli:v4.6)
-FROM registry.ci.openshift.org/ocp/4.8:cli AS origincli
-
-#@follow_tag(openshift-ose-base:ubi8)
-FROM registry.ci.openshift.org/ocp/4.8:base
+FROM centos:centos8 AS centos
 RUN INSTALL_PKGS=" \
       openssl \
       rsync \
@@ -53,7 +48,6 @@ COPY --from=builder /go/src/github.com/openshift/cluster-logging-operator/manife
 RUN rm /manifests/art.yaml
 
 
-COPY --from=origincli /usr/bin/oc /usr/bin
 COPY --from=builder /go/src/github.com/openshift/cluster-logging-operator/must-gather/collection-scripts/* /usr/bin/
 
 # this is required because the operator invokes a script as `bash scripts/cert_generation.sh`