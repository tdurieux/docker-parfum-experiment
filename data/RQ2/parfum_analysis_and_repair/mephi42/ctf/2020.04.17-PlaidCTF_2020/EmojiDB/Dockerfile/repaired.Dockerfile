FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y language-pack-en && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y valgrind && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y electric-fence && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xterm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@dev

RUN sed -i 's/# deb-src/deb-src/g' /etc/apt/sources.list
RUN apt-get -y update

RUN useradd -m ctf

COPY bin /home/ctf
COPY emojidb.xinetd /etc/xinetd.d/emojidb

RUN chown -R root:root /home/ctf
EXPOSE 9876
CMD ["/home/ctf/start.sh"]
