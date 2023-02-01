FROM debian:buster as stage

ARG PACKAGE_BASEURL=https://download.zerotier.com/debian/buster/pool/main/z/zerotier-one/
ARG ARCH=amd64
ARG VERSION

RUN apt-get update -qq && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL -o zerotier-one.deb "${PACKAGE_BASEURL}/zerotier-one_${VERSION}_${ARCH}.deb"

FROM debian:buster

RUN apt-get update -qq && apt-get install --no-install-recommends openssl libssl1.1 -y && rm -rf /var/lib/apt/lists/*;

COPY --from=stage zerotier-one.deb .

RUN dpkg -i zerotier-one.deb && rm -f zerotier-one.deb
RUN echo "${VERSION}" >/etc/zerotier-version
RUN rm -rf /var/lib/zerotier-one

COPY entrypoint.sh.release /entrypoint.sh
RUN chmod 755 /entrypoint.sh

HEALTHCHECK --interval=1s CMD bash /healthcheck.sh

CMD []
ENTRYPOINT ["/entrypoint.sh"]
