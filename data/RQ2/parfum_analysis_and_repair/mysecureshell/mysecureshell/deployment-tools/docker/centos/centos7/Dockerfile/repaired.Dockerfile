FROM centos:centos7
MAINTAINER Pierre Mavro <deimos@deimos.fr>

##################
# User Quick Try #
##################

RUN yum -y install whois procps openssh-server && rm -rf /var/cache/yum
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd

#######
# DEV #
#######

RUN yum -y install git && rm -rf /var/cache/yum
RUN git clone https://github.com/mysecureshell/mysecureshell.git
RUN yum -y install libacl1-dev libgnutls28-dev gcc make && rm -rf /var/cache/yum
RUN yum -y install fakeroot devscripts autotools-dev && rm -rf /var/cache/yum
RUN yum -y install sphinx-doc sphinx-common python3-sphinx libjs-sphinxdoc \
 python-pip texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended && rm -rf /var/cache/yum
RUN pip install --no-cache-dir sphinx_rtd_theme

# Start SSHd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
