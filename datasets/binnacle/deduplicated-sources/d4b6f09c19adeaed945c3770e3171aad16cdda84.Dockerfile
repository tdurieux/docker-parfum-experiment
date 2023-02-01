FROM bitwalker/alpine-elixir:1.7.3

# Set up an Alpine Linux machine running an SSH server.
# Autogenerate missing host keys.

RUN apk add --update --no-cache openssh sudo git perl-utils bash
RUN ssh-keygen -A
RUN printf "PermitUserEnvironment yes\n" >> /etc/ssh/sshd_config

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
ADD fixtures /fixtures
RUN chmod -R a+x /fixtures/bin
RUN printf 'export PATH=$PATH:/fixtures/bin\n' >> /etc/profile
RUN printf "PATH=$PATH:/fixtures/bin\nBOOTLEG_PATH=/project\n" > /etc/skel/.ssh/environment

# Create git repository
RUN mkdir -p /opt/repos/
RUN git init --bare /opt/repos/simple.git

RUN mkdir -p /tmp/app/simple
WORKDIR /tmp/app/simple
RUN git init
RUN git config user.email local@example.com
RUN git config user.name Miscellaneous Minstrel
RUN echo "Foobar" > README.md
RUN git add .
RUN git commit -m "Initial commit"
RUN git remote add origin /opt/repos/simple.git
RUN git push origin master

# Run SSH daemon and expose the standard SSH port.
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]

# For debugging, let sshd be more verbose:
# CMD ["/usr/sbin/sshd", "-D", "-d", "-d", "-d", "-e"]
