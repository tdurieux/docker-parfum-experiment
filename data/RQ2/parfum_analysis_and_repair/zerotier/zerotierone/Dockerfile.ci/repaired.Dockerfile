FROM ubuntu:21.04 as stage

RUN apt-get update -qq && apt-get -qq -y --no-install-recommends install make clang && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN /usr/bin/make
RUN echo $PWD
RUN cp zerotier-one /usr/sbin

FROM ubuntu:21.04

COPY --from=stage /zerotier-one /usr/sbin
RUN ln -sf /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool
RUN ln -sf /usr/sbin/zerotier-one /usr/sbin/zerotier-cli

RUN echo "${VERSION}" > /etc/zerotier-version
RUN rm -rf /var/lib/zerotier-one


RUN apt-get -qq update
RUN apt-get -qq -y --no-install-recommends install iproute2 net-tools fping 2ping iputils-ping iputils-arping && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh.release /entrypoint.sh
RUN chmod 755 /entrypoint.sh

CMD []
ENTRYPOINT ["/entrypoint.sh"]
