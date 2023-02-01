FROM alisw/slc6-builder:latest

# Install CVMFS.
RUN curl -f -L https://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM > /etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM && \
    curl -f -L https://cvmrepo.web.cern.ch/cvmrepo/yum/cernvm.repo > /etc/yum.repos.d/cernvm.repo && \
    rpm --rebuilddb && yum install -y cvmfs && rm -rf /var/cache/yum

# Install XRootD.
RUN curl -f -L https://xrootd.org/binaries/xrootd-stable-slc6.repo > /etc/yum.repos.d/xrootd.repo && \
    rpm --rebuilddb && yum install -y xrootd-client && rm -rf /var/cache/yum

# Install EOS.
COPY eos.repo /etc/yum.repos.d/eos.repo
RUN rpm --rebuilddb && yum install -y eos-client && rm -rf /var/cache/yum

# Parrot configuration.
ENV PARROT_ALLOW_SWITCHING_CVMFS_REPOSITORIES=yes \
    PARROT_CVMFS_REPO=<default-repositories>\ alice-ocdb.cern.ch:url=http://cvmfs-stratum-one.cern.ch/cvmfs/alice-ocdb.cern.ch,pubkey=/etc/cvmfs/keys/cern.ch/cern-it1.cern.ch.pub \
    HTTP_PROXY=DIRECT; \
    PARROT_CVMFS_ALIEN_CACHE=/cvmfs_alien_cache

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "zsh" ]
