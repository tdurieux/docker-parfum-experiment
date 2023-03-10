FROM alpine:3.15

ARG go_pkg_url

RUN apk add --no-cache --update alpine-sdk linux-headers cmake openssh curl


RUN adduser -D -s /bin/ash jenkins && \
    passwd -u jenkins && \
    ssh-keygen -A && \
    mkdir /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins

RUN curl -f -s $go_pkg_url -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz

COPY authorized_keys /home/jenkins/.ssh/authorized_keys
RUN chown -R jenkins:jenkins /home/jenkins/.ssh && \
    chmod 600 /home/jenkins/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

