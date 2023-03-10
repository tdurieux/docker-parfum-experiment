FROM ubuntu:bionic

RUN apt update && apt -y --no-install-recommends install openssh-server sudo && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/run/sshd

RUN groupadd -r gossh && useradd -m -s /bin/bash -g gossh gossh
RUN adduser gossh sudo

RUN groupadd -r hobgob && useradd -m -s /bin/bash -g hobgob hobgob
RUN adduser hobgob sudo

RUN echo 'root:rootpwd' | chpasswd
RUN echo 'gossh:gosshpwd' | chpasswd
RUN echo 'hobgob:hobgobpwd' | chpasswd

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 22
CMD ["/run.sh"]
