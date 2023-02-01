from ubuntu:20.04

run groupadd -r ctf && useradd --no-log-init -r -g ctf ctf

run apt-get update && apt-get upgrade -y
run apt-get install --no-install-recommends -y socat python3 qemu-user-static libncurses5 libncurses5-dev gdb-multiarch && rm -rf /var/lib/apt/lists/*;

copy ./sparc-1 ./run_socat.sh ./flag.txt /chall/

WORKDIR /chall
run chmod 644 flag.txt
run chmod 744 run_socat.sh sparc-1

CMD /chall/run_socat.sh