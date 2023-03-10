FROM vesoft/nebula-dev:centos7 as builder

ARG BRANCH=master

COPY . /home/nebula/BUILD

RUN cd /home/nebula/BUILD/package \
  && ./package.sh -v $(git rev-parse --short HEAD) -n OFF -b ${BRANCH}

FROM centos:7

COPY --from=builder /home/nebula/BUILD/build/cpack_output/nebula-*-common.rpm /usr/local/nebula/nebula-common.rpm
COPY --from=builder /home/nebula/BUILD/build/cpack_output/nebula-*-storage.rpm /usr/local/nebula/nebula-storaged.rpm

WORKDIR /usr/local/nebula

RUN rpm -ivh *.rpm \
  && mkdir -p ./{logs,data,pids} \
  && rm -rf *.rpm

EXPOSE 9777 9778 9779 9780 19779 19780

ENTRYPOINT ["/usr/local/nebula/bin/nebula-storaged", "--flagfile=/usr/local/nebula/etc/nebula-storaged.conf", "--daemonize=false"]