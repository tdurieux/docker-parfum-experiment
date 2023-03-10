FROM ubuntu
ENV USER nutty
RUN useradd $USER

COPY initramfs.cpio /home/$USER/initramfs.cpio
COPY bzImage /home/$USER/bzImage
COPY start.sh /home/$USER/start.sh
COPY run.sh /home/$USER/run.sh
COPY pow.py /home/$USER/pow.py
COPY hashcash.py /home/$USER/hashcash.py

RUN chown -R root:$USER /home/$USER
RUN chmod -R 555 /home/$USER
EXPOSE 1337
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xinetd python2 qemu qemu-system-x86 && rm -rf /var/lib/apt/lists/*;
COPY $USER.xinetd /etc/xinetd.d/$USER

CMD service xinetd start && sleep 2 && tail -f /var/log/xinetdlog
