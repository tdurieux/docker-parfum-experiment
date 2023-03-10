# CLion remote docker environment (How to build docker container, run and stop it)
#
# Build and run:
#   docker build -t ostis/clion-remote-cpp-env:0.5 -f Dockerfile.clion-cpp-env .
#   docker run -d --cap-add sys_ptrace -p127.0.0.1:2222:22 --name clion_remote_env ostis/clion-remote-cpp-env:0.5
#   ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:2222"
#
# stop:
#   docker stop clion_remote_env
#
# ssh credentials (test user):
#   user@password

FROM ostis/ostis:0.5.0

RUN apt-get update \
  && apt-get install --no-install-recommends -y ssh \
      gdb \
      rsync \
      tar \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
    echo 'ChrootDirectory /'; \
  ) > /etc/ssh/sshd_config_test_clion \
  && mkdir /run/sshd

RUN useradd -m user \
  && yes password | passwd user

RUN chmod ugo+rw /ostis/sc-machine /ostis/sc-machine/bin /ostis/kb /ostis/problem-solver

WORKDIR /ostis/problem-solver

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_test_clion"]

