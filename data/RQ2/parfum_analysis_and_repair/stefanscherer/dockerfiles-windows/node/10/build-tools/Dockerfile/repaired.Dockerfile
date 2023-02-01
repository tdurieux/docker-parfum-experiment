ARG node=node:10.19.0-windowsservercore
FROM $node

RUN npm install --global --production --add-python-to-path windows-build-tools --vs2015 && npm cache clean --force;
