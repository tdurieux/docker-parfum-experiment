# See Guides to learn how to start a container: https://postgres.ai/docs/how-to-guides/administration/engine-manage

FROM docker:20.10.12

# Install dependencies.
RUN apk update && apk add zfs=0.8.4-r0 --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.12/main \
  && apk add --no-cache lvm2 bash util-linux
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/main' >> /etc/apk/repositories \
  && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/community' >> /etc/apk/repositories \
  && apk add --no-cache bcc-tools=0.18.0-r0 bcc-doc=0.18.0-r0 && ln -s $(which python3) /usr/bin/python \
  # TODO: remove after release the PR: https://github.com/iovisor/bcc/pull/3286 (issue: https://github.com/iovisor/bcc/issues/3099)
  && wget https://raw.githubusercontent.com/iovisor/bcc/master/tools/biosnoop.py -O /usr/share/bcc/tools/biosnoop

ENV PATH="${PATH}:/usr/share/bcc/tools"

WORKDIR /home/dblab

COPY ./bin/dblab-server ./bin/dblab-server
COPY ./configs/standard ./standard
COPY ./api ./api
COPY ./scripts ./scripts

CMD ./bin/dblab-server
