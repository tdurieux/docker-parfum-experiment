FROM apache/nifi:latest

RUN mkdir nifi-1.8.0 && cp -a conf nifi-1.8.0/conf

COPY --chown=nifi:nifi start-patched.sh ../scripts

RUN chmod a+x ../scripts/start-patched.sh

ENTRYPOINT ../scripts/start-patched.sh
