# Based on the deprecated `https://github.com/tutumcloud/tutum-debian`
FROM debian:stretch

# Install packages
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        dos2unix \
        openssh-server \
        openjdk-8-jdk \
        pwgen \
        && \
mkdir -p /var/run/sshd && \
sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config && rm -rf /var/lib/apt/lists/*;

ENV AUTHORIZED_KEYS **None**

ADD run.sh /run.sh
RUN dos2unix /run.sh \
    && chmod +x /*.sh

RUN apt-get update
RUN apt install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
        sudo net-tools wget \
        curl vim man faketime unzip less \
        iptables iputils-ping logrotate && \
    apt-get remove -y --purge --auto-remove systemd && rm -rf /var/lib/apt/lists/*;

EXPOSE 22
CMD ["/run.sh"]
