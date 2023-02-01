FROM haconiwa-container:base

ENV IMAGE_NAME ssh
ENV NOTVISIBLE "in users profile"

RUN apt update -yy && \
    apt install --no-install-recommends -yy openssh-server && rm -rf /var/lib/apt/lists/*;

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
