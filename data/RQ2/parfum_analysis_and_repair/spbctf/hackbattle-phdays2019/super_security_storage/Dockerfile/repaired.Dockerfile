FROM debian:latest

EXPOSE 18800

RUN apt-get update && apt-get -y --no-install-recommends install open-cobol xinetd && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/storage
COPY . .
RUN cobc -free -x -o storage.elf super_security_storage.CBL
RUN cp xinetd.conf /etc/xinetd.d/storage
RUN service xinetd restart

CMD script -c "xinetd -d"
