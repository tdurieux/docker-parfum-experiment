--- a/Dockerfile
+++ b/Dockerfile
@@ -145,6 +145,17 @@
  && apt-get -y install "linux-headers-${KERNEL_VERSION}" dkms \
  && apt-get clean
 
+# Install Mellanox driver
+ARG MLNX_EN_VERSION=5.0-1.0.0.0
+RUN curl -fsSL http://linux.mellanox.com/public/repo/mlnx_en/${MLNX_EN_VERSION}/ubuntu20.04/mellanox_mlnx_en.list \
+      -o /etc/apt/sources.list.d/mellanox.list \
+ && curl -fsSL https://www.mellanox.com/downloads/ofed/RPM-GPG-KEY-Mellanox | apt-key add - \
+ && apt-get update \
+ && apt-get -y install libc6-dev mlnx-en-dkms \
+ && MODULE=$(dkms status | awk -F'[,: ]+' '$1 == "mlnx-en" {print $1 "/" $2}') \
+ && KERNEL=$(ls -1 /lib/modules/ | tail -n1) \
+ && dkms install "$MODULE" -k "$KERNEL"
+
 # Install DRBD modules
 RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC1B5A793C04BB3905AD837734893610CEAA9512 \
  && echo "deb http://ppa.launchpad.net/linbit/linbit-drbd9-stack/ubuntu focal main" \
@@ -178,6 +189,10 @@
 COPY --from=rootfs / /rootfs
 COPY --from=modules /lib/modules/ /rootfs/lib/modules/
 
+# Fix: mlx4_core should load mlx4_en (LP: #1115710)
+RUN echo 'softdep mlx4_core post: mlx4_en' \
+      > /rootfs/etc/modprobe.d/mlx4.conf
+
 # Generate initramfs with new modules
 RUN chroot /rootfs/ update-initramfs -u