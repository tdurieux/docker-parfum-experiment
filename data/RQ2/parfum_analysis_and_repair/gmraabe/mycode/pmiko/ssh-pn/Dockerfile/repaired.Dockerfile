FROM ubuntu:latest

# build with:  sudo docker build --tag ssh-pn .
# run with:    sudo docker run -d ssh-pn

ARG user=student
ARG pass=alta3
ARG gh_user=alta3-student1

RUN apt-get update && \
    apt-get install --no-install-recommends -y jq curl sudo vim openssh-server man less python git && \
    mkdir /var/run/sshd && \
    echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config && rm -rf /var/lib/apt/lists/*;

# create user, set password
RUN useradd --create-home --shell /bin/bash ${user}                                                           && \ 
    install --directory --owner=${user} --group=${user} /home/${user}/.ssh                                    && \ 
    echo "${user}:${pass}" | chpasswd                                                                         && \ 
    echo "export LC_ALL=C" >> /home/${user}/.bashrc                                                          

# allow root ssh with password and set password
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config                    && \
    echo "root:${pass}" | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]

