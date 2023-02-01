FROM alpine:3.7

# Set up an Alpine Linux machine running an SSH server.
# Autogenerate missing host keys.

RUN apk add --update --no-cache openssh sudo
RUN ssh-keygen -A

# Create the skeleton directory, used for creating new users.

RUN mkdir -p /etc/skel/.ssh
RUN chmod 700 /etc/skel/.ssh

RUN touch /etc/skel/.ssh/authorized_keys
RUN chmod 600 /etc/skel/.ssh/authorized_keys

# Allow members of group "wheel" to execute any command.

RUN echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/wheel

# Allow passwordless sudo for users in the "passwordless-sudoers" group.
# Users in this group may run commands as any user in any group.

RUN addgroup -S passwordless-sudoers
RUN echo "%passwordless-sudoers ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/yolo

# Add fixture data for tests
COPY fixtures /fixtures

# Set up a subsystem
RUN echo "Subsystem greeting-subsystem echo Hello, who am I talking to?; while :; do read varname; echo It\'s nice to meet you \$varname; done" >> /etc/ssh/sshd_config

# Run SSH daemon and expose the standard SSH port.
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]

# For debugging, let sshd be more verbose:
# CMD ["/usr/sbin/sshd", "-D", "-d", "-d", "-d", "-e"]
