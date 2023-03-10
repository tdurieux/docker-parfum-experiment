FROM alpine AS builder

ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
RUN apk add --no-cache curl && curl -f -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1
FROM arm32v7/python:bullseye
ARG usesource="https://hub.fastgit.xyz/TechXueXi/TechXueXi.git"
ARG usebranche="dev"
ENV pullbranche=${usebranche}
ENV Sourcepath=${usesource}
COPY --from=builder qemu-arm-static /usr/bin
# RUN \
#  sed -i 's/snapshot.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list ;\
#  sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list ;\
#  sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list ;
# 增加适配玩客云arm7 32位环境 chrome默认安装 90版本
RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split
RUN ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
RUN ln -s /bin/tar /usr/sbin/tar
RUN apt-get update
#RUN apt-get upgrade
RUN apt-get install --no-install-recommends -y wget unzip libzbar0 git cron supervisor chromium-driver; rm -rf /var/lib/apt/lists/*; chromedriver --version; which chromedriver; chromium --version
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt1-dev zlib1g-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
ENV TZ=Asia/Shanghai
ENV AccessToken=
ENV Secret=
ENV Nohead=True
ENV Pushmode=1
ENV islooplogin=False
#ENV Sourcepath="https://hub.fastgit.xyz/TechXueXi/TechXueXi.git"
ENV CRONTIME="30 9 * * *"
# RUN rm -f /xuexi/config/*; ls -la
COPY requirements.txt /xuexi/requirements.txt
COPY run.sh /xuexi/run.sh
COPY start.sh /xuexi/start.sh
COPY supervisor.sh /xuexi/supervisor.sh
RUN pip install --no-cache-dir -r /xuexi/requirements.txt

WORKDIR /xuexi
RUN chmod +x ./run.sh
RUN chmod +x ./start.sh
RUN chmod +x ./supervisor.sh;./supervisor.sh
RUN mkdir code
WORKDIR /xuexi/code
#RUN git clone -b ${pullbranche} ${Sourcepath}
RUN git clone -b ${usebranche} ${usesource};cp -r /xuexi/code/TechXueXi/SourcePackages/* /xuexi;
WORKDIR /xuexi
EXPOSE 80
ENTRYPOINT ["/bin/bash", "./start.sh"]
