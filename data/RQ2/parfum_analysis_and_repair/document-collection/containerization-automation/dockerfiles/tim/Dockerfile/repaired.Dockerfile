FROM zjzstu/deepin-wine:latest
LABEL maintainer "zhujian <zjzstu@github.com>"

WORKDIR /app
RUN set -eux && \
    apt-get update && \
    apt-get install --no-install-recommends -y wget ttf-wqy-microhei gosu dbus && \
    gosu nobody true && \
    wget https://mirrors.aliyun.com/deepin/pool/non-free/d/deepin.com.qq.office/deepin.com.qq.office_2.0.0deepin4_i386.deb && \
    useradd -s /bin/bash -m user && \
    chown -R user:user /app && \
    dpkg -i *.deb && \
    rm -f *.deb && \
    apt-get autoclean -y && apt-get clean -y && \
	find /var/lib/apt/lists -type f -delete && \
	find /var/cache -type f -delete && \
	find /var/log -type f -delete && \
	find /usr/share/doc -type f -delete && \
	find /usr/share/man -type f -delete && rm -rf /var/lib/apt/lists/*;

COPY docker-entrypoint.sh ./
RUN chmod a+x docker-entrypoint.sh && \
	chown user:user docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]