ARG API_VERSION=1.39
ARG ENGINE_VERSION=19.03.12

FROM docker:${ENGINE_VERSION}-dind

RUN apk add --no-cache \
		openssh

# Add the keys and set permissions
RUN ssh-keygen -A

# copy the test SSH config
RUN echo "IgnoreUserKnownHosts yes" > /etc/ssh/sshd_config && \
  echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
  echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# set authorized keys for client paswordless connection
COPY tests/ssh-keys/authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

RUN echo "root:root" | chpasswd
RUN ln -s /usr/local/bin/docker /usr/bin/docker
EXPOSE 22