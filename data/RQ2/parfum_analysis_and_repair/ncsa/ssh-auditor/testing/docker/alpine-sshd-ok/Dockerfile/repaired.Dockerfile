FROM alpine
RUN apk update
RUN apk add --no-cache openssh
RUN ssh-keygen -A
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
