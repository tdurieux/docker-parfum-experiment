FROM ubuntu:21.04

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y musl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install --no-install-recommends -y python2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python2 get-pip.py
RUN pip2 install --no-cache-dir pwntools
RUN apt-get install --no-install-recommends -y libc6-dbg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/pwndbg/pwndbg
RUN mkdir /var/run/sshd
RUN echo 'root:123456789' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN chmod +x /pwndbg/setup.sh
WORKDIR /pwndbg
RUN ./setup.sh
WORKDIR /
# CHANGE
COPY mooosl /root/mooosl
RUN chmod +x /root/mooosl
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 22
