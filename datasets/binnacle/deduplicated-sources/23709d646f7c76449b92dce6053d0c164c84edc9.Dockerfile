FROM alpine
COPY inspectit-ocelot-agent.jar /
COPY entrypoint.sh  /
ENTRYPOINT ["sh", "/entrypoint.sh"]