FROM ubuntu:vivid

MAINTAINER VonC <vonc@laposte.net>

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -yq update \
  && apt-get -yqq --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:git-core/ppa \
  && add-apt-repository ppa:hloeung/gnupg2 \
  && apt-get -yq update \
  && apt-get -yqq --no-install-recommends install \
     wget \
     curl \
     ca-certificates \
     git \
     openssl \
     ldap-utils \
     iputils-ping \
     gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --group --shell /bin/sh git &&\
    mkdir /home/git/bin
COPY profile /home/git/.profile
COPY bashrc /home/git/.bashrc
COPY bash_aliases /home/git/.bash_aliases
RUN mkdir /home/git/.ssh
COPY curl-ca-bundle.crt /home/git/.ssh/
RUN mkdir -p /home/git/sbin/usrcmd
COPY get_tpl_value /home/git/sbin/usrcmd/
COPY .gitconfig /home/git/
RUN chmod +x /home/git/sbin/usrcmd/get_tpl_value &&\
    chown -R git:git /home/git
ENV PATH="$PATH:/home/git/bin"
WORKDIR /home/git
COPY bash_aliases /root/.bash_aliases
ENTRYPOINT [ "bash" ]
CMD [ "-l" ]
