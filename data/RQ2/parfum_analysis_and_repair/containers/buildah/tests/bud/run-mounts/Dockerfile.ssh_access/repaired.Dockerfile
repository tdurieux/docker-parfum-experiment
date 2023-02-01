FROM alpine

RUN apk add --no-cache openssh-client

RUN --mount=type=ssh,id=default ssh-add -l -E md5
RUN ssh-add -l -E md5
RUN cat /run/buildkit/ssh_agent.0
