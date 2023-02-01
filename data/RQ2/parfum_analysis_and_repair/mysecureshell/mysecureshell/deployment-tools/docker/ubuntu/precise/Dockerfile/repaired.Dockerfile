FROM debian:lucid
MAINTAINER Pierre Mavro <deimos@deimos.fr>

##################
# User Quick Try #
##################

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y -o Dpkg::Options::="--force-confdef" \
 -o Dpkg::Options::="--force-confold" install whois procps openssh-server install whois procps openssh-server && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd

#######
# DEV #
#######

RUN apt-get update
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/mysecureshell/mysecureshell.git
RUN apt-get -y --no-install-recommends install libacl1-dev libgnutls-dev gcc make && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential fakeroot lintian devscripts debhelper ubuntu-dev-tools \
 cowbuilder autotools-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install sphinx-doc sphinx-common python3-sphinx libjs-sphinxdoc \
 python-pip texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN pip install --no-cache-dir sphinx_rtd_theme

# Start SSHd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
