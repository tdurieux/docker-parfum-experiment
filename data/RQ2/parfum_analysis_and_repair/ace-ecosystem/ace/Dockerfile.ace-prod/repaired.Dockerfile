FROM ace-base:latest
USER ace
WORKDIR /opt/ace
COPY --chown=ace:ace . /opt/ace
# TODO get rid of this ace-ssl image somehow
COPY --from=ace-ssl:latest --chown=ace:ace /ssl /opt/ace/ssl
RUN docker/provision/ace/install