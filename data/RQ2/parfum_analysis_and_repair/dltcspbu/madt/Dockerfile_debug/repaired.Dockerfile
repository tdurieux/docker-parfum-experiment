ARG MADT_TAG=latest
FROM madt:${MADT_TAG}
RUN apk add --no-cache -U nano \
               htop \
               openssh

RUN echo "root:debug" | chpasswd && \
    sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/g' /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

ENTRYPOINT /usr/sbin/sshd -E /home/demo/ssh.log; \
           dockerd --oom-score-adjust 500 --log-level debug & \
           pid=$!; \
           make build; \
           docker build -t madt/nginx /madt/tutorials/basic; \
           docker build -t madt/pyget /madt/tutorials/monitoring; \
           $(cd /madt/tutorials/monitoring && python3 lab.py); \
           madt_ui 80
#           wait $pid

