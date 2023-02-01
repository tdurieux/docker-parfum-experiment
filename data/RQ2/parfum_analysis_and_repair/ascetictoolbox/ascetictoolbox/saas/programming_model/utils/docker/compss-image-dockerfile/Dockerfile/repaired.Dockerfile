FROM ubuntu:14.04
RUN apt-get install --no-install-recommends -y wget && \
    wget https://compss.bsc.es/releases/repofiles/repo_deb_ubuntu_x86-64.list -O /etc/apt/sources.list.d/compss-framework_x86-64.list && \
    wget -qO - https://compss.bsc.es/repo/debs/deb-gpg-bsc-grid.pub.key | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y compss-framework openssh-client openssh-server ssh && \
    echo "export PATH=$PATH:/opt/COMPSs/Runtime/scripts/user/" >> /root/.bashrc && \
    mkdir /var/run/sshd && \
    echo 'root:screencast' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV NOTVISIBLE "in users profile"