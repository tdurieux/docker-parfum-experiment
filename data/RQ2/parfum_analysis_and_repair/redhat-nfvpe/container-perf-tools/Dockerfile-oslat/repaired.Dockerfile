FROM ubi8
USER root
COPY oslat/cmd.sh /root
COPY common-libs /root/common-libs
RUN RT_TEST=$( curl -f -L https://www.rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/ 2>/dev/null | sed -n -r 's/.*href=\"(rt-tests-2.1-2.*.rpm).*/\1/p') \
    && yum -y install https://www.rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/${RT_TEST} \
    && yum -y install which numactl-libs \
    && yum clean all && rm -rf /var/cache/yum \
    && curl -f -L -o /root/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
    && chmod 777 /root/dumb-init \
    && chmod 777 /root/cmd.sh
WORKDIR /root
ENTRYPOINT ["/root/dumb-init", "--"]
CMD ["/root/cmd.sh"]

