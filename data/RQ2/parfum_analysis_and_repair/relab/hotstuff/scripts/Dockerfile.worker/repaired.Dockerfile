FROM ubuntu:rolling

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;

# allow root login and pubkey authentication
RUN sed -i s/#PermitRootLogin.*/PermitRootLogin\ prohibit-password/ /etc/ssh/sshd_config
RUN sed -i s/#PubkeyAuthentication.*/PubkeyAuthentication\ yes/ /etc/ssh/sshd_config

ADD scripts/entrypoint.sh /entrypoint.sh

WORKDIR /root
ADD scripts/id.pub .ssh/authorized_keys

ENTRYPOINT [ "/entrypoint.sh", "sleep", "infinity"]
