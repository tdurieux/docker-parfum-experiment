FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y xinetd telnetd && rm -rf /var/lib/apt/lists/*;
RUN useradd -m -d /home/marie -s /bin/bash marie
RUN echo 'marie:poppins' | chpasswd
RUN useradd -m -d /home/jane -s /bin/bash jane
COPY inetd.conf /etc/inetd.conf
COPY xinetd.conf /etc/xinetd.conf
COPY telnet /etc/xinetd.d/telnet
COPY flag.txt /home/jane/flag.txt
RUN chmod a+r /home/jane/flag.txt

EXPOSE 23
CMD ["sleep", "360"]
