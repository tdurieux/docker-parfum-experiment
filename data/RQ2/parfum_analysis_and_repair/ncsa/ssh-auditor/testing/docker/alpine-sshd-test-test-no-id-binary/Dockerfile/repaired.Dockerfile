FROM alpine
RUN apk update
RUN apk add --no-cache openssh
RUN ssh-keygen -A
RUN echo -e "test\ntest"|adduser test
RUN rm /usr/bin/id
ADD sshd_config /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
