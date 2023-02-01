# onewayhash
ARG registry
FROM $registry/labtainer.base
ARG lab
ARG labdir
ARG imagedir
ARG apt_source
ARG user_name
ARG password
ENV APT_SOURCE $apt_source
RUN /usr/bin/apt-source.sh
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl \
    openssh-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
    hexedit && rm -rf /var/lib/apt/lists/*;
ADD $labdir/sys_$lab.tar.gz /

RUN useradd -ms /bin/bash $user_name
RUN echo "$user_name:$password" | chpasswd
RUN adduser $user_name sudo
USER $user_name
ENV HOME /home/$user_name
ADD $labdir/$lab.tar.gz $HOME
#ENTRYPOINT sudo /sbin/faux_init && bash
USER root
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
