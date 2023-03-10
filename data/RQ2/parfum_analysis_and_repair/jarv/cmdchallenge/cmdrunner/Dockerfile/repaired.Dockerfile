FROM ubuntu:18.04
COPY runcmd/runcmd /usr/local/bin/runcmd
COPY oops/oops /usr/local/bin/oops-this-will-delete-bin-dirs
RUN apt-get update && \
      apt-get install --no-install-recommends -y jq bc rename bsdmainutils man file && \
      rm -f /etc/bash.bashrc && rm -rf /etc/bash_completion.d && \
      rm -f /root/.bashrc && \
      ln -s /ro_volume/ch /usr/local/bin/ch && rm -rf /var/lib/apt/lists/*;
ADD var.tar.gz /
