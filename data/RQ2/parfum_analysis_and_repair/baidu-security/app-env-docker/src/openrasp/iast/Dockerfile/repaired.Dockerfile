FROM openrasp/centos7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

RUN yum install -y gcc python36 python3-devel sqlite-devel && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir -r https://raw.githubusercontent.com/baidu-security/openrasp-iast/master/openrasp_iast/requirements.txt

COPY start.sh /root/

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
