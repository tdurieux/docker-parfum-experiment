ARG node=node
FROM $node
RUN npm install -g rebase-docker-image && npm cache clean --force;
ENTRYPOINT [ "rebase-docker-image.cmd" ]
