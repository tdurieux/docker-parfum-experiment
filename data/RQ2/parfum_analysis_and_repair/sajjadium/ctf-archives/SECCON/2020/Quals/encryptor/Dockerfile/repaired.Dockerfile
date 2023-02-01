FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get -y update --fix-missing && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install xxd && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;

# Add users
RUN groupadd -r admin && useradd -r -g admin admin
RUN groupadd pwn && useradd -g pwn pwn
RUN printf "/bin/bash\n" | chsh pwn

# Add files
ADD secret.key /secret.key # prepare your own
ADD encryptor  /home/pwn/encryptor
RUN chmod 440 /secret.key
RUN chmod 555 /home/pwn/encryptor

# Set privilege
RUN chown -R pwn:pwn /home/pwn
RUN chown root:admin /secret.key
RUN chown pwn:admin /home/pwn/encryptor
RUN chmod g+s       /home/pwn/encryptor

WORKDIR /home/pwn/
USER pwn
