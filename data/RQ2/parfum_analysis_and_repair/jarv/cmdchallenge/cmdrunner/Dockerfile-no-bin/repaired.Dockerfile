FROM ubuntu:16.04
COPY runcmd/runcmd /usr/local/bin/runcmd
COPY oops/oops /usr/local/bin/oops-this-will-delete-bin-dirs

RUN rm -f /etc/bash.bashrc && rm -rf /etc/bash_completion.d && \
      rm -f /root/.bashrc && \
      ln -s /ro_volume/ch /usr/local/bin/ch && \
      mv /bin/bash /usr/local/bin/bash && \
      rm -f /usr/sbin/* && \
      rm -f /usr/bin/* && \
      rm -f /bin/*
ADD var.tar.gz /