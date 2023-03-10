ARG OS
ARG VERSION
FROM ghcr.io/baikalgroup/baikal-dev:${OS}-${VERSION} as builder
ARG OS
ARG VERSION
WORKDIR /work
COPY . ./BaikalDB/
RUN tar xfz bazelcache.tgz && cd BaikalDB \ 
&& env HOME=/work USER=work bazelisk build //:all \
&& bash ./ci/package.sh version=nightly os=${OS}-${VERSION} && rm bazelcache.tgz

RUN mkdir /work/output && tar xfz /work/pack/baikal-all-nightly-${OS}-${VERSION}.tgz -C /work/output \
&& cp /work/BaikalDB/insider-preview/entrypoint.sh /work/output && chmod +x /work/output/entrypoint.sh && rm /work/pack/baikal-all-nightly-${OS}-${VERSION}.tgz



FROM ${OS}:${VERSION}
ARG OS
ARG VERSION

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG=en_US.utf8

RUN if [ "$VERSION" = "16.04" ]; then SSL_LIB="libssl1.0" ; else SSL_LIB="libssl1.1" ;fi \
&& if [ "${OS}" = "ubuntu" ]; then \
 apt-get update && apt-get install --no-install-recommends -y curl $SSL_LIB && rm -rf /var/lib/apt/lists/*; \
elif [ "${OS}" = "centos" ] ; then \
yum update -y && yum install -y file && yum clean all && rm -rf /var/cache/yum; \
fi

# copy artifacts
COPY --from=builder /work/output /app/

WORKDIR /app/
ENTRYPOINT [ "/app/entrypoint.sh" ]
