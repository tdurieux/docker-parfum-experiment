FROM cyberninjas/pam_aad:ubuntu

RUN unset VERSION DEBVER && \
    apt update && apt install --no-install-recommends -y \
        gdb \
        openssh-server \
        pamtester \
        strace \
        syslog-ng \
        vim && rm -rf /var/lib/apt/lists/*;

ENV PAMDIR "/lib/x86_64-linux-gnu/security"
WORKDIR /usr/src/pam_aad
CMD ["make", "-eC", "test"]
