FROM --platform=$BUILDPLATFORM golang as build
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ENV GOPATH=/go
ADD . /go/src/github.com/kubernetes-sigs/alibaba-cloud-csi-driver/
WORKDIR /go/src/github.com/kubernetes-sigs/alibaba-cloud-csi-driver
RUN env GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d '/') GOOS=linux CGO_ENABLED=0 go build -ldflags "-X main._BRANCH_='v1.0.0' -X main._VERSION_='v1.14.5' -X main._BUILDTIME_=`date '+%Y-%m-%d-%H:%M:%S'`" -o plugin.csi.alibabacloud.com && env GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d '/') GOOS=linux CGO_ENABLED=0 go build ./build/multi-private/csiplugin-connector.go

FROM registry.cn-hangzhou.aliyuncs.com/acs/centos:7-update
LABEL maintainers="Alibaba Cloud Authors" description="Alibaba Cloud CSI Plugin"
RUN yum install -y ca-certificates file tzdata nfs-utils xfsprogs e4fsprogs pciutils nc && rm -rf /var/cache/yum
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./build/multi-private/ /multi_data

RUN cp /multi_data/$(echo $TARGETPLATFORM | cut -f2 -d '/')-nsenter /usr/bin/nsenter; cp /multi_data/$(echo $TARGETPLATFORM | cut -f2 -d '/')-nsenter /nsenter
RUN if [[ $(echo $TARGETPLATFORM | cut -f2 -d '/') == "arm64" ]]; then cp /multi_data/$(echo $TARGETPLATFORM | cut -f2 -d '/')-ossfs /usr/bin/ossfs; cp /multi_data/$(echo $TARGETPLATFORM | cut -f2 -d '/')-ossfs /usr/local/bin/ossfs; fi

ARG ossfsVer=1.80.6.ack.1
ARG update_ossfsVer=1.86.1.ack.1
RUN if [[ $(echo $TARGETPLATFORM | cut -f2 -d '/') == "amd64" ]]; then \
 curl -f https://ack-csiplugin.oss-cn-hangzhou.aliyuncs.com/ossfs/ossfs_${ossfsVer}-b42b3a8_centos7.0_x86_64.rpm -o /root/ossfs_${ossfsVer}_centos7.0_x86_64.rpm; fi
RUN if [[ $(echo $TARGETPLATFORM | cut -f2 -d '/') == "amd64" ]]; then \
 curl -f https://ack-csiplugin.oss-cn-hangzhou.aliyuncs.com/pre/ossfs/ossfs_${update_ossfsVer}-ca30fc4_centos7.0_x86_64.rpm -o /root/ossfs_1.86.4_centos7.0_x86_64.rpm; fi
RUN if [[ $(echo $TARGETPLATFORM | cut -f2 -d '/') == "amd64" ]]; then \
 curl -f https://ack-csiplugin.oss-cn-hangzhou.aliyuncs.com/pre/ossfs/ossfs_${update_ossfsVer}-75ed4f1_centos8_x86_64.rpm -o /root/ossfs_1.86.4_centos8_x86_64.rpm; fi

RUN if [[ $(echo $TARGETPLATFORM | cut -f2 -d '/') == "amd64" ]]; then \
 mv /multi_data/jindofs-fuse-3.7.3-20211207.tar.gz /; tar zvxf /jindofs-fuse-3.7.3-20211207.tar.gz -C /; rm /jindofs-fuse-3.7.3-20211207.tar.gz fi
RUN if [[ $(echo $TARGETPLATFORM | cut -f2 -d '/') == "arm64" ]]; then mkdir /acs; mv /multi_data/$(echo $TARGETPLATFORM | cut -f2 -d '/')-fuse-2.9.2-11.el7.aarch64.rpm /acs/fuse-2.9.2-11.el7.aarch64.rpm; mv /multi_data/$(echo $TARGETPLATFORM | cut -f2 -d '/')-fuse-libs-2.9.2-11.el7.aarch64.rpm /acs/fuse-libs-2.9.2-11.el7.aarch64.rpm; mv /multi_data/which-2.20-7.el7.aarch64.rpm /acs/which-2.20-7.el7.aarch64.rpm; mv /multi_data/libfuse.so.2 /acs/libfuse.so.2; fi
RUN mv /multi_data/$(echo $TARGETPLATFORM | cut -f2 -d '/')-entrypoint.sh /entrypoint.sh
COPY ./build/multi/csiplugin-connector.service /bin/csiplugin-connector.service
COPY ./build/multi/freezefs.sh /freezefs.sh
COPY --from=build /go/src/github.com/kubernetes-sigs/alibaba-cloud-csi-driver/csiplugin-connector /bin/csiplugin-connector
COPY --from=build /go/src/github.com/kubernetes-sigs/alibaba-cloud-csi-driver/plugin.csi.alibabacloud.com /bin/plugin.csi.alibabacloud.com
RUN chmod +x /bin/plugin.csi.alibabacloud.com && chmod +x /entrypoint.sh && chmod +x /bin/csiplugin-connector && chmod +x /bin/csiplugin-connector.service && chmod +x /usr/bin/nsenter && chmod +x /nsenter && chmod +x /freezefs.sh
RUN if [[ $(echo $TARGETPLATFORM | cut -f2 -d '/') == "arm64" ]]; then chmod +x /usr/bin/ossfs && chmod +x /usr/local/bin/ossfs; fi
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
ENTRYPOINT ["/entrypoint.sh"]