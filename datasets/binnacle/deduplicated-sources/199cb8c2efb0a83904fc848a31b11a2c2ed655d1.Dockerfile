ARG registry 
FROM $registry/labtainer.base
MAINTAINER jkhosali@nps.edu
ARG lab
ARG labdir
ARG imagedir
ARG user_name
ARG apt_source

ENV APT_SOURCE $apt_source
RUN /usr/bin/apt-source.sh
RUN apt-get update && apt-get install -y --no-install-recommends zsh
RUN echo "# This secret file is generated when container is created" >> /root/.secret
RUN echo "# The root secret string below will be replaced with a keyed hash" >> /root/.secret
RUN echo "My ROOT secret string is: ROOT_SECRET" >> /root/.secret
ADD $labdir/sys_$lab.tar.gz /
RUN useradd -ms /bin/bash $user_name
RUN echo "$user_name:$user_name" | chpasswd
RUN adduser $user_name sudo
USER $user_name
ENV HOME /home/$user_name
ADD $labdir/$lab.tar.gz $HOME
RUN echo "# This secret file is generated when container is created" >> $HOME/.secret
RUN echo "# The user secret string below will be replaced with a keyed hash" >> $HOME/.secret
RUN echo "My Ubuntu secret string is: UBUNTU_SECRET" >> $HOME/.secret
USER root
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
