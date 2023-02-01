FROM debian:bullseye AS build
ARG APT_PKGS=
ARG DEPENDS_ENV=
ARG DEPENDS_ARGS=
ARG MAKE_ENV=
COPY ./docs/ndndpdk-depends.sh /root/ndndpdk-depends.sh
RUN sh -c 'apt-get -y -qq update' && \
    apt-get -y -qq install --no-install-recommends ca-certificates curl jq lsb-release ${APT_PKGS} && \
    env SKIPROOTCHECK=1 ${DEPENDS_ENV} /root/ndndpdk-depends.sh --dir=/root/ndndpdk-depends -y ${DEPENDS_ARGS} && \
    rm -rf /root/ndndpdk-depends
COPY . /root/ndn-dpdk/
RUN export PATH=$PATH:/usr/local/go/bin && \
    cd /root/ndn-dpdk && \
    corepack pnpm install && \
    env ${MAKE_ENV} make && \
    make install
RUN rm -rf \
      /usr/local/bin/__pycache__ \
      /usr/local/bin/dpdk-dumpcap \
      /usr/local/bin/dpdk-pdump \
      /usr/local/bin/dpdk-proc-info \
      /usr/local/bin/dpdk-test* \
      /usr/local/bin/meson \
      /usr/local/bin/pip* \
      /usr/local/bin/spdk_* \
      /usr/local/bin/wheel \
      /usr/local/etc \
      /usr/local/games \
      /usr/local/go \
      /usr/local/include \
      /usr/local/lib/pkgconfig \
      /usr/local/lib/python* \
      /usr/local/lib/systemd \
      /usr/local/man \
      /usr/local/sbin \
      /usr/local/share/dpdk \
      /usr/local/share/man \
      /usr/local/share/polkit-1 \
      /usr/local/share/xdp-tools \
      /usr/local/src && \
    for F in /usr/local/lib/*.so /usr/local/bin/*; do \
      ldd "$F" 2>/dev/null | awk 'NF==4 && $2=="=>" && $3~"^/" {print $3}'; \
    done | sort -u | grep -vE '^/usr/local/' > /libs.txt && \
    while read -r F; do \
      dpkg-query -S "$F" 2>/dev/null || dpkg-query -S $(readlink -f "$F") 2>/dev/null || true; \
    done < /libs.txt | cut -d: -f1 | sort -u > /pkgs.txt

FROM debian:bullseye
COPY --from=build /pkgs.txt /
RUN apt-get -y -qq update && \
    apt-get -y -qq install --no-install-recommends iproute2 jq $(cat /pkgs.txt) && \
    rm -rf /var/lib/apt/lists/* /pkgs.txt
COPY --from=build /usr/local/ /usr/local/
RUN ldconfig
VOLUME /run/ndn
CMD ["/usr/local/bin/ndndpdk-svc", "--gqlserver", "http://:3030"]
