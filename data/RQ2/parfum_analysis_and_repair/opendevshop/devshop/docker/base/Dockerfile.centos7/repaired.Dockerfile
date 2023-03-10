FROM centos:7
LABEL maintainer="Jon Pugh"
ENV bin_dir /usr/local/bin
ENV INIT_COMMAND /lib/systemd/systemd

# Tell the "run-quiet" script to only show us stderr.
ENV OUTPUT err
# Copy only needed files, then run systemd prep, to speed up builds.
# docker-systemd-prepare layer will only be rebuild if these files change.
COPY ./docker/bin/run-quiet $bin_dir
COPY ./docker/bin/docker-systemd-prepare $bin_dir
COPY ./docker/bin/docker-systemd-entrypoint $bin_dir
RUN chmod +x $bin_dir/*
RUN run-quiet docker-systemd-prepare

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

# The Entrypoint script runs the CMD after starting up SystemD.
ENTRYPOINT ["docker-systemd-entrypoint"]

# CMD can be changed to run a script or command as soon as the container (and SystemD) is up.
CMD []