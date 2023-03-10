FROM debian:stable

RUN mkdir /var/run/sshd
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server sudo && rm -rf /var/lib/apt/lists/*;

RUN useradd vagrant --create-home --user-group --groups sudo
RUN echo 'vagrant:vagrant' | chpasswd

# Optional: Allow logging in as root to be able to test bootstrap with
# using user root.
RUN echo root:vagrant' | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
