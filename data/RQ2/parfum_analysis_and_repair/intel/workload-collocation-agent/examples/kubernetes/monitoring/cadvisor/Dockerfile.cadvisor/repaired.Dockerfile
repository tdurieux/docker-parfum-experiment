FROM alpine:3.12 AS build

RUN apk --no-cache add libc6-compat device-mapper findutils zfs build-base linux-headers go bash git wget cmake pkgconfig ndctl-dev && \
    apk --no-cache add thin-provisioning-tools --repository http://dl-3.alpinelinux.org/alpine/edge/main/ && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -rf /var/cache/apk/*

RUN git clone -b v02.00.00.3820 https://github.com/intel/ipmctl/ && \
    cd ipmctl && \
    mkdir output && \
    cd output && \
    cmake -DRELEASE=ON -DCMAKE_INSTALL_PREFIX=/ -DCMAKE_INSTALL_LIBDIR=/usr/local/lib .. && \
    make -j all && \
    make install

RUN wget https://sourceforge.net/projects/perfmon2/files/libpfm4/libpfm-4.10.1.tar.gz && \
  echo "78599e1668142f48c24afb1f79ca00a89df51b65  libpfm-4.10.1.tar.gz" | sha1sum -c  && \
  tar -xzf libpfm-4.10.1.tar.gz && \
  rm libpfm-4.10.1.tar.gz

RUN export DBG="-g -Wall" && \
  make -e -C libpfm-4.10.1 && \
  make install -C libpfm-4.10.1

RUN wget https://golang.org/dl/go1.13.15.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go1.13.15.linux-amd64.tar.gz && \
  rm -f go1.13.15.linux-amd64.tar.gz

ENV PATH=$PATH::/usr/local/go/bin
RUN git clone --depth=1 --single-branch --branch jwalecki/merged-features https://github.com/wacuuu/cadvisor.git
WORKDIR cadvisor

ENV GOROOT /usr/local/go/
ENV GOPATH /go
ENV GO_FLAGS="-tags=libpfm,libipmctl,netgo"
RUN ./build/build.sh


FROM alpine:3.12

RUN apk --no-cache add libc6-compat device-mapper findutils zfs ndctl && \
    apk --no-cache add thin-provisioning-tools --repository http://dl-3.alpinelinux.org/alpine/edge/main/ && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -rf /var/cache/apk/*

# Grab cadvisor, libpfm4, and libipmctl from "build" container.
COPY --from=build /usr/local/lib/libpfm.so* /usr/local/lib/
COPY --from=build /usr/local/lib/libipmctl.so* /usr/local/lib/
COPY --from=build /cadvisor/cadvisor /usr/bin/cadvisor

EXPOSE 8080

ENV CADVISOR_HEALTHCHECK_URL=http://localhost:8080/healthz

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --quiet --tries=1 --spider $CADVISOR_HEALTHCHECK_URL || exit 1

ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]