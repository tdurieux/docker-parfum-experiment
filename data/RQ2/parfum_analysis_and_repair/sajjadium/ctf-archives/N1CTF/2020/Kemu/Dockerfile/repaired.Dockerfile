FROM ubuntu:18.04
RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup
RUN rm -f /etc/apt/sources.list
COPY ./sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y --no-install-recommends install qemu-system-x86 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libsdl2-2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libnfs11 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libsnappy1v5 && rm -rf /var/lib/apt/lists/*;
COPY ./flag /
RUN chmod 444 /flag
ADD pwn_file.tar.gz /home/
WORKDIR /home/pwn_file
RUN useradd -m pwn
USER pwn
CMD /home/pwn_file/launch.sh
