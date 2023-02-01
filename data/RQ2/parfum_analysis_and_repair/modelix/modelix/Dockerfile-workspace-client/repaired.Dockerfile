FROM modelix/modelix-projector

USER root

COPY workspace-client/build/libs/workspace-client-latest-all.jar /home/projector-user/workspace-client.jar
COPY workspace-client/download-workspace-and-start-projector.sh /

RUN chown -R projector-user:projector-user /home/projector-user/
USER projector-user

WORKDIR /home/projector-user/
CMD ["/download-workspace-and-start-projector.sh"]