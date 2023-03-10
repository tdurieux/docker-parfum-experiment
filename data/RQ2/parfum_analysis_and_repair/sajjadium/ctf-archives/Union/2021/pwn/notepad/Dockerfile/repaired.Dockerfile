FROM ubuntu:20.04
ENV USER notepad
RUN useradd $USER

COPY flag.txt /home/$USER/flag.txt
COPY notepad /home/$USER/notepad

RUN chown -R root:$USER /home/$USER
RUN chmod -R 555 /home/$USER
EXPOSE 1337
RUN apt-get update && apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;
COPY $USER.xinetd /etc/xinetd.d/$USER

CMD service xinetd start && sleep 2 && tail -f /var/log/xinetdlog
