ARG BIT_IMAGE=latest
FROM bitcli/bit:${BIT_IMAGE}
ARG SCOPE_PATH=/root/remote-scope
WORKDIR ${SCOPE_PATH}
RUN bit init --bare
CMD bit start