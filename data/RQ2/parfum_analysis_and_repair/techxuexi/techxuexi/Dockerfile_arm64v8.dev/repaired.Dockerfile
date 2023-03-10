FROM alpine AS builder

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add --update --no-cache curl && curl -f -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1


FROM arm64v8/python:3.7-slim

COPY --from=builder qemu-aarch64-static /usr/bin
ARG usesource="https://hub.fastgit.xyz/TechXueXi/TechXueXi.git"
ARG usebranche="dev"
ENV pullbranche=${usebranche}
ENV Sourcepath=${usesource}

RUN \
  sed -i 's/snapshot.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list ;\
  sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list ;\
  sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list ;

# RUN \
#   mkdir ~/.pip ;\
#   echo -e "\n[global]\ntrusted-host=mirrors.aliyun.com\nindex-url=https://mirrors.aliyun.com/pypi/simple/" > ~/.pip/pip.conf; \
#   cat ~/.pip/pip.conf

RUN apt-get update && apt-get install --no-install-recommends -y wget unzip libzbar0 git cron supervisor chromium-driver; && rm -rf /var/lib/apt/lists/*; chromedriver --version; which chromedriver; chromium --version
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
