FROM corda/corda-zulu-java1.8-4.4

# Copy corda files
ADD --chown=corda:corda node.conf               /opt/corda/node.conf
ADD --chown=corda:corda cordapps/               /opt/corda/cordapps

# Copy node info watcher script
ADD --chown=corda:corda node_info_watcher.sh    /opt/corda/

COPY --chown=corda:corda run-corda.sh /opt/corda/bin/run-corda

RUN chmod +x /opt/corda/bin/run-corda && \
    chmod +x /opt/corda/node_info_watcher.sh && \
    sync

# Working directory for Corda
WORKDIR /opt/corda
ENV HOME=/opt/corda

# Start it
CMD ["run-corda"]