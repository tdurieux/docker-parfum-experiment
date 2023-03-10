FROM modelix/modelix-mps
WORKDIR /usr/modelix-ui

COPY artifacts/de.itemis.mps.extensions/ /mps-plugins/de.itemis.mps.extensions/

COPY build/org.modelix/build/artifacts/org.modelix/plugins/ /mps-plugins/modelix-base/
RUN rm -rf /mps-plugins/modelix-base/org.modelix.ui.server
RUN /install-plugins.sh