--- Dockerfile.s390x_old	2020-02-27 10:20:26.726219542 +0000
+++ Dockerfile.s390x	2020-02-27 10:23:31.466315390 +0000
@@ -9,7 +9,7 @@
 RUN for i in ${QEMU_ARCHS}; do curl -f -L https://github.com/multiarch/qemu-user-static/releases/download/v${QEMU_VERSION}/qemu-${i}-static.tar.gz | tar zxvf - -C /usr/bin; done
 RUN chmod +x /usr/bin/qemu-*

-FROM s390x/golang:1.11.9-alpine3.8
+FROM s390x/golang:1.12.14-alpine3.10
 MAINTAINER LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)

 ARG MANIFEST_TOOL_VERSION=v0.7.0
@@ -29,7 +29,7 @@
 # Install util-linux for column command (used for output formatting).
 # Install grep and sed for use in some Makefiles (e.g. pulling versions out of glide.yaml)
 # Install shadow for useradd (it allows to use big UID)
-RUN apk add --no-cache su-exec curl bash git openssh mercurial make wget util-linux tini file grep sed shadow
+RUN apk update && apk add --no-cache su-exec curl bash git openssh mercurial make wget util-linux tini file grep sed shadow
 RUN apk upgrade --no-cache

 # Disable ssh host key checking
@@ -54,8 +54,9 @@
 RUN go get github.com/onsi/ginkgo/ginkgo

 # Install linting tools.
-RUN wget -O - -q https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.20.0
-RUN golangci-lint --version
+RUN go get -u gopkg.in/alecthomas/gometalinter.v2	
+RUN ln -s `which gometalinter.v2` /usr/local/bin/gometalinter	
+RUN gometalinter --install

 # Install license checking tool.
 RUN go get github.com/pmezard/licenses
