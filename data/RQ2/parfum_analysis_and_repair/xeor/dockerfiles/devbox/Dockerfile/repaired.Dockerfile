FROM xeor/base:7.1-4

MAINTAINER Lars Solberg <lars.solberg@gmail.com>
ENV REFRESHED_AT 2015-03-18

RUN yum update -y && \
      yum install -y strace curl wget vim emacs-nox diffstat tmux gcc gcc-c++ zeromq3-devel \
        freetype-devel libpng-devel \
        git mercurial \
        tar unzip make \
        postgresql \
        lsof net-tools nmap && \
      yum clean all && rm -rf /var/cache/yum

# Python stuff
ADD requirements.txt ./
RUN yum install -y python-setuptools python-devel && \
    easy_install pip && \
    pip install --no-cache-dir -r /requirements.txt && rm -rf /var/cache/yum

# npm
RUN yum install -y nodejs && \
    curl -f https://www.npmjs.com/install.sh | clean=no sh && rm -rf /var/cache/yum

## Ninjab (the prompt)
RUN cd /root && \
    git clone https://github.com/xeor/ninjab.git && \
    echo '. /root/ninjab/loader' >> /.profile

COPY init/ /init/

VOLUME /data
WORKDIR /data

