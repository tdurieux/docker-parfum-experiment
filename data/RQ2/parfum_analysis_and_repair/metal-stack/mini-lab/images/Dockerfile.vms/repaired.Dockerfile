FROM ubuntu:20.04

RUN apt update -y && \
    apt install --no-install-recommends -y qemu-system-x86 ovmf ifupdown net-tools telnet && rm -rf /var/lib/apt/lists/*;

CMD ["/mini-lab/vms_entrypoint.sh"]
