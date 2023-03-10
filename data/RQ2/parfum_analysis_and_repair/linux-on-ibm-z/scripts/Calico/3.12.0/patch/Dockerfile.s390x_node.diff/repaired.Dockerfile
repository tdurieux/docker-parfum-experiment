--- Dockerfile.s390x_old	2020-03-04 13:03:56.074848765 +0000
+++ Dockerfile.s390x	2020-03-04 13:06:27.024848765 +0000
@@ -18,33 +18,7 @@
 FROM ${QEMU_IMAGE} as qemu
 FROM ${BIRD_IMAGE} as bird
 
-FROM s390x/debian:buster-slim as bpftool-build
-
-COPY --from=qemu /usr/bin/qemu-s390x-static /usr/bin/
-
-RUN apt-get update && \
-apt-get upgrade -y && \
-apt-get install -y --no-install-recommends \
-    gpg gpg-agent libelf-dev libmnl-dev libc-dev iptables libgcc-8-dev \
-    bash-completion binutils binutils-dev make git curl \
-    ca-certificates xz-utils gcc pkg-config bison flex build-essential && \
-apt-get purge --auto-remove && \
-apt-get clean
-
-WORKDIR /tmp
-
-RUN \
-git clone --depth 1 -b master git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git && \
-cd linux/tools/bpf/bpftool/ && \
-sed -i '/CFLAGS += -O2/a CFLAGS += -static' Makefile && \
-sed -i 's/LIBS = -lelf $(LIBBPF)/LIBS = -lelf -lz $(LIBBPF)/g' Makefile && \
-printf 'feature-libbfd=0\nfeature-libelf=1\nfeature-bpf=1\nfeature-libelf-mmap=1' >> FEATURES_DUMP.bpftool && \
-FEATURES_DUMP=`pwd`/FEATURES_DUMP.bpftool make -j `getconf _NPROCESSORS_ONLN` && \
-strip bpftool && \
-ldd bpftool 2>&1 | grep -q -e "Not a valid dynamic program" \
-	-e "not a dynamic executable" || \
-	( echo "Error: bpftool is not statically linked"; false ) && \
-mv bpftool /usr/bin && rm -rf /tmp/linux
+FROM calico/bpftool:v5.3-s390x as bpftool
 
 FROM s390x/alpine:3.8
 MAINTAINER LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)
@@ -71,7 +45,7 @@
 # Copy in the calico-node binary
 COPY dist/bin/calico-node-${ARCH} /bin/calico-node
 
-COPY --from=bpftool-build /usr/bin/bpftool /bin
+COPY --from=bpftool /bpftool /bin
 
 RUN rm /usr/bin/qemu-${ARCH}-static