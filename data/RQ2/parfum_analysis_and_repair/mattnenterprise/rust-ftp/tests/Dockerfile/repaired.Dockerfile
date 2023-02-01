FROM ubuntu:20.04

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -yqq vsftpd && rm -rf /var/lib/apt/lists/*;

ADD vsftpd.conf /etc/vsftpd.conf

RUN useradd -s /bin/bash -d /home/ftp -m -c "Doe ftp user" -g ftp Doe &&\
    echo "Doe:mumble"| chpasswd &&\
    echo "/etc/init.d/vsftpd start" | tee -a /etc/bash.bashrc

CMD ["/bin/bash"]
