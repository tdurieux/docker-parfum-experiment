FROM debian:jessie-slim

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN useradd nopasswd -p ""
ADD credentials.json /app/credentials.json
COPY suid.txt once-suid.txt gid.txt once-gid.txt /app/
RUN chmod u+s /app/suid.txt /app/once-suid.txt && chmod g+s /app/gid.txt /app/once-gid.txt
RUN chmod u-s /app/once-suid.txt && chmod g-s /app/once-gid.txt && echo "once" >> /app/once-suid.txt
ENV MYSQL_PASSWD password
RUN rm /sbin/unix_chkpwd /usr/bin/*
VOLUME /usr
