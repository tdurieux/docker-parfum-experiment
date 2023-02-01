FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-pyicu && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libstdc++6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install xinetd && rm -rf /var/lib/apt/lists/*;

RUN useradd -m ctf

ADD start.sh /root
ADD Release/jsc /home/ctf
ADD Release/lib /home/ctf/lib
ADD server.py /home/ctf
ADD flag /root

ADD run.sh /home/ctf
ADD dfg.xinetd /etc/xinetd.d/dfg
ADD readflag /

RUN chmod +x /root/start.sh && \
    chmod +x /home/ctf/jsc && \
    chmod +x /home/ctf/server.py && \
    chmod +x /home/ctf/lib/libJavaScriptCore.so.1 && \
    chmod +x /home/ctf/run.sh && \
    chown -R root:ctf /home/ctf && \
    chmod -R 750 /home/ctf/   && \
    chmod 4755 /readflag && \
    chmod 400 /root/flag

EXPOSE 1212
ENTRYPOINT /root/start.sh
