FROM ubuntu:20.04
RUN apt-get update && apt-get install --no-install-recommends -y xinetd python && rm -rf /var/lib/apt/lists/*;
RUN useradd -M blacklist
RUN mkdir /home/blacklist/

WORKDIR /
COPY genfiles.py flag /
RUN python genfiles.py /flag
RUN rm genfiles.py flag

WORKDIR /home/blacklist/
COPY blacklist .

COPY xinetd /etc/xinetd.conf
EXPOSE 1337
ENTRYPOINT ["/usr/sbin/xinetd", "-dontfork"]
