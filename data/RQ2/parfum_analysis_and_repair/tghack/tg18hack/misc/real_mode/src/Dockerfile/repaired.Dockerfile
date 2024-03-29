FROM ubuntu:16.04

RUN apt update && apt install --no-install-recommends -y qemu-system-i386 socat python-minimal && rm -rf /var/lib/apt/lists/*;
RUN useradd -m -s /bin/bash real
USER real
COPY run.py run.sh bin/bios.bin /home/real/

WORKDIR /home/real
ENTRYPOINT [ "/bin/bash", "-c", "/home/real/run.sh" ]
