FROM ubuntu:16.04
MAINTAINER hackability@naver.com

# Environment
ENV user=free

# add user && config
RUN useradd -m -d /home/$user/ -s /bin/bash $user
RUN echo "$user     hard    nproc   20" >> /etc/security/limits.conf

# update && install xinetd
RUN apt-get update && apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;

# COPY
COPY ./free /home/$user/free
COPY ./flag /home/$user/flag
COPY ./xinetd_conf /etc/xinetd.d/xinetd_conf

# apply permissions
RUN chown -R root:$user /home/$user
RUN chmod -R 750 /home/$user
RUN chmod 440 /home/$user/flag

# EXPOSE
EXPOSE 20300

# CMD
CMD ["/usr/sbin/xinetd", "-d"]
