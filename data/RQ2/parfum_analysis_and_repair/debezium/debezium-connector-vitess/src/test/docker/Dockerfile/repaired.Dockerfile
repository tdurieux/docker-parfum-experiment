# Use a temporary layer for the build stage.
FROM vitess/base:v12.0.3 AS base

FROM vitess/lite:v12.0.3

USER root

RUN apt-key adv --no-tty --recv-keys --keyserver keyserver.ubuntu.com 467B942D3A79BD29
RUN apt-get update && apt-get install --no-install-recommends -y sudo curl vim jq && rm -rf /var/lib/apt/lists/*;

# Install etcd
COPY install_local_dependencies.sh /vt/dist/install_local_dependencies.sh
RUN /vt/dist/install_local_dependencies.sh

# Copy binaries used by vitess components start-up scripts
COPY --from=base /vt/bin/vtctl /vt/bin/
COPY --from=base /vt/bin/mysqlctl /vt/bin/

# Copy vitess components start-up scripts
COPY local /vt/local

USER vitess
ENV PATH /vt/bin:$PATH
ENV PATH /var/opt/etcd:$PATH
CMD cd /vt/local && ./initial_cluster.sh && tail -f /dev/null
