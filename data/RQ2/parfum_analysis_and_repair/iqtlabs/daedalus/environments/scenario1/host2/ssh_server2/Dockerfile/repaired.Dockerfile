FROM maltyxx/sshd
RUN apt-get update && apt-get install --no-install-recommends -y nfs-common && rm -rf /var/lib/apt/lists/*;
