FROM ubuntu
MAINTAINER yuawn
RUN apt-get update
RUN apt-get install xinetd -y
RUN apt-get install libc6-dev-i386 -y
RUN useradd -m final_countdown
RUN chown -R root:root /home/final_countdown
CMD ["/usr/sbin/xinetd","-dontfork"]