FROM alpine
RUN apk update
RUN apk add --no-cache openssh
RUN apk add --no-cache mtr
RUN apk add --no-cache nmap
RUN apk add --no-cache iperf
RUN apk add --no-cache socat
RUN apk add --no-cache vim
RUN apk add --no-cache nano
RUN apk add --no-cache curl
RUN apk add --no-cache links
RUN apk add --no-cache iputils
RUN apk add --no-cache bind-tools
RUN apk add --no-cache rsync
RUN apk add --no-cache bash
VOLUME /root/.ssh /etc/ssh /data
ADD start-ssh.sh /bin/start-ssh.sh
