FROM modelix/modelix-projector-base

USER root

COPY artifacts/de.itemis.mps.extensions/ /mps-plugins/MPS-extensions
COPY build/org.modelix/build/artifacts/org.modelix/plugins/ /mps-plugins/modelix

RUN /install-plugins.sh /projector/ide/plugins/
COPY projector-user-home /home/projector-user
COPY log.xml /projector/ide/bin/log.xml

RUN chown -R projector-user:projector-user /home/projector-user
RUN chown -R projector-user:projector-user /mps-plugins
RUN chown -R projector-user:projector-user /mps-languages
RUN chown -R projector-user:projector-user /projector/ide/

USER projector-user