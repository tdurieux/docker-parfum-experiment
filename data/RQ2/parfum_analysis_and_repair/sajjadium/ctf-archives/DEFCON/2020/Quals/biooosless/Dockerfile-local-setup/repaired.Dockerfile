from ubuntu:18.04

run apt-get -qq update && apt-get install -y -qq --no-install-recommends python3 python3-pip qemu-system-x86 && rm -rf /var/lib/apt/lists/*;

copy bios-template.bin /
copy floppy-dummy-flag.img /
copy local-run.py /

cmd tail -f /dev/null
