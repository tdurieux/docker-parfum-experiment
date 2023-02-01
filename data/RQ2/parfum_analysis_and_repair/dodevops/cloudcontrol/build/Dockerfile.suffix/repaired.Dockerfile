# Features

COPY feature /home/cloudcontrol/feature-installers
COPY assets/feature-installer-utils.sh /

# CCC

COPY --from=cccBuild /build/ccc /usr/local/ccc/ccc
RUN chmod +x /usr/local/ccc/ccc

COPY --from=cccClientBuild /build/dist /usr/local/ccc/client

# Cloud control

COPY assets/cloudcontrol.sh /usr/local/bin/cloudcontrol
RUN chmod +x /usr/local/bin/cloudcontrol

# Chown