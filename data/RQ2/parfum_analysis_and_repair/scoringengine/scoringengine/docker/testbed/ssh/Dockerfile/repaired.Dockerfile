FROM ubuntu:18.04

RUN \
  apt-get update && \
  mkdir /var/run/sshd && \
  apt-get install --no-install-recommends -y openssh-server && \
  useradd -m ttesterson && \
  useradd -m rpeterson && \
  echo 'ttesterson:testpass' | chpasswd && \
  echo 'rpeterson:otherpass' | chpasswd && rm -rf /var/lib/apt/lists/*;


EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
