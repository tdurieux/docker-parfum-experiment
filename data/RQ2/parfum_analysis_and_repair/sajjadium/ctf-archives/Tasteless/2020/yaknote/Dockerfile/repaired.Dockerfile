FROM ubuntu
RUN apt-get update && apt-get -y --no-install-recommends install qemu-system-x86 && rm -rf /var/lib/apt/lists/*;
ADD initrd.gz bzImage /initrd.gz run.sh /
ENTRYPOINT [ "/run.sh" ]