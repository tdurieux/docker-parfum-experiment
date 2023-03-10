FROM abrt/faf
# rhbz#1733043 workaround
ENV TERM=linux

USER root

# install devel tools
RUN dnf -y install git-core make rpm-build sudo tito vim which

# Copy sources to the docker image
COPY --chown=faf:faf . /faf/

# From not on work from faf directory
WORKDIR '/faf'

# Change owner of /faf, clean git and install dependences
RUN git clean -dfx && \
    dnf -y --setopt=strict=0 --setopt=tsflags=nodocs builddep faf.spec && \
    dnf clean all

# Build as non root
USER faf

ENV HOME /faf

# Build faf
RUN tito build --rpm --test

#And continue as root
USER 0

# Update ABRT Analytics (FAF)
RUN rpm -Uvh /tmp/tito/noarch/faf-* && \
    sed -i -e"s/everyone_is_admin\s*=\s*false/everyone_is_admin = true/i" /etc/faf/plugins/web.conf && \
    echo 'Defaults    env_keep = "PGHOST PGUSER PGPASSWORD PGPORT PGDATABASE RDSBROKER RDSBACKEND"' >> /etc/sudoers.d/faf && \
    /usr/libexec/fix-permissions /faf && \
    /usr/libexec/fix-permissions /run/faf-celery && \
    /usr/libexec/fix-permissions /var/log/faf && \
    /usr/libexec/fix-permissions /var/spool/faf && \
    /usr/libexec/fix-permissions /etc/faf/

#Switch workdir back to /
WORKDIR '/'