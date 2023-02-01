FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y language-pack-en && rm -rf /var/lib/apt/lists/*;

RUN useradd -m ctf

COPY bin /home/ctf
COPY emojidb.xinetd /etc/xinetd.d/emojidb

RUN chown -R root:root /home/ctf
EXPOSE 9876
CMD ["/home/ctf/start.sh"]
