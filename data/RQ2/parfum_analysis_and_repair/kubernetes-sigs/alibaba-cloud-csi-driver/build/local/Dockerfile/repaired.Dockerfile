FROM ubuntu:20.04

LABEL maintainers="Alibaba Cloud Authors"
LABEL description="Alibaba Cloud CSI Plugin"

RUN apt update && apt upgrade -y && apt install --no-install-recommends -y ca-certificates file tzdata lvm2 && rm -rf /var/lib/apt/lists/*;
COPY nsenter /nsenter

COPY plugin.csi.alibabacloud.com /bin/plugin.csi.alibabacloud.com
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /bin/plugin.csi.alibabacloud.com && chmod +x /entrypoint.sh && sed -i 's/use_lvmetad\ =\ 1/use_lvmetad\ =\ 0/g' /etc/lvm/lvm.conf

ENTRYPOINT ["/entrypoint.sh"]
