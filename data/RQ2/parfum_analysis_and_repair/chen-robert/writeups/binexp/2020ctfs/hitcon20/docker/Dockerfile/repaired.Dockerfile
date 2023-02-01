FROM ubuntu:18.04
MAINTAINER ddaa
RUN apt update -y && apt install --no-install-recommends nginx fcgiwrap libsodium23 libmsgpackc2 libjson-c3 -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -m ctf
RUN chmod 774 /tmp
RUN chmod -R 774 /var/tmp
RUN chmod -R 774 /dev
RUN chmod 1733 /tmp /var/tmp /dev/shm
RUN chown -R root:root /home/ctf
CMD ["/home/ctf/run.sh"]
