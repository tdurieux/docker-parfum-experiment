FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server locales python-simplejson vim && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN locale-gen en_US.UTF-8

VOLUME /scripts

COPY ./files /scripts

WORKDIR /scripts

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]