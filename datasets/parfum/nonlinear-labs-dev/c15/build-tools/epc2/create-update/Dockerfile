FROM archlinux:20200908
  
COPY createUpdate.sh /createUpdate.sh
COPY base-packages.txt /base-packages.txt
COPY update-packages.txt /update-packages.txt
COPY build-packages.txt /build-packages.txt
COPY setup-base-os.sh /setup-base-os.sh
COPY packages /packages

RUN /setup-base-os.sh
